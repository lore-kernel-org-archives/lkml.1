Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZGRB2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZGRB2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 21:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbZGRB2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 21:28:30 -0400
Received: from sous-sol.org ([216.99.217.87]:51617 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751936AbZGRB23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 21:28:29 -0400
Date: Fri, 17 Jul 2009 18:28:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Sage Weil <sage@newdream.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] ceph: Ceph distributed file system client v0.10
Message-ID: <20090718012819.GE8150@sequoia.sous-sol.org>
References: <1247693090-27796-1-git-send-email-sage@newdream.net> <87hbxcx182.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907161004080.8026@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907161004080.8026@cobra.newdream.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sage Weil (sage@newdream.net) wrote:
> I don't always verify that things like element counts are "sane", though, 
> so there's currently the possibility of trying to allocate large chunks of 
> memory.

There's also the potential of allocating a small amount of memory w/ a
large element count if you overflow on multiply.  You should definitely
protect against this if you have such code in ceph client (kcalloc has
simple example defense).

thanks,
-chris

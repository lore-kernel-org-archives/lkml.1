Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZDVUAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZDVUAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756379AbZDVUAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:00:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52549 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbZDVUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:00:04 -0400
Date: Wed, 22 Apr 2009 21:00:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David <david@unsolicited.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc3: Warning during boot (ReiserFS)
Message-ID: <20090422200002.GO8633@ZenIV.linux.org.uk>
References: <49EF685E.7040004@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF685E.7040004@unsolicited.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 07:56:30PM +0100, David wrote:
> I'm seeing the following warning in my log during boot with rc3 /
> ReiserFS. System seems OK afterward.

Yeah, the sanity check had caught another place misusing lookup_one_len().
I'd keep the warning in place for now; I think I know how to deal with
reiserfs side of things, but if it turns out too invasive for post-rc3,
we can always turn the check off just for -final.  For now I'd keep the
check in place, just to see if anything else runs into it.

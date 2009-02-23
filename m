Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbZBWBfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbZBWBfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 20:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZBWBf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 20:35:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbZBWBf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 20:35:29 -0500
Date: Sun, 22 Feb 2009 17:34:46 -0800
From: Jeff Layton <jlayton@redhat.com>
To: Horst Reiterer <horst.reiterer@gmail.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] Re: [PATCH] fs/cifs: send SMB_COM_FLUSH in
 cifs_fsync
Message-ID: <20090222173446.2da6b182@tupile.poochiereds.net>
In-Reply-To: <alpine.OSX.2.00.0902222206360.7676@horst-reiterers-macbook-air.local>
References: <alpine.OSX.2.00.0902202138421.3998@horst-reiterers-macbook-air.local>
	<524f69650902201721l1c7f0d34p4708980a90d7fc8f@mail.gmail.com>
	<alpine.OSX.2.00.0902222137080.7676@horst-reiterers-macbook-air.local>
	<524f69650902221303h37feb366k3d89a07bfd100ea3@mail.gmail.com>
	<alpine.OSX.2.00.0902222206360.7676@horst-reiterers-macbook-air.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009 22:12:11 +0100 (CET)
Horst Reiterer <horst.reiterer@gmail.com> wrote:

> On Sun, 22 Feb 2009, Steve French wrote:
> > Suggestions on what to call such a new mount option?  How about
> > "nostrictfsync"  ?
> 
> Sound good, should be self-explanatory for Samba users and those familiar
> with the fsync concept.
> 
> Horst.

My suggestion would be to not add a new option until someone requests
it/complains about it. We already have a lot of unneeded/unused mount
options, and I think this will just be adding one to the pile.

My $.02...

-- 
Jeff Layton <jlayton@redhat.com>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZGUR7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZGUR7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZGUR7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:59:05 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:35714 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZGUR7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:59:04 -0400
Subject: Re: Error mounting FC8 NFS server with 2.6.31-rc3 NFSv4 client.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
In-Reply-To: <4A65FCB2.6080903@candelatech.com>
References: <4A64EB1F.4000602@candelatech.com>
	 <1248178527.5222.0.camel@heimdal.trondhjem.org>
	 <4A65F184.5060802@candelatech.com>
	 <1248196339.21343.8.camel@heimdal.trondhjem.org>
	 <4A65FCB2.6080903@candelatech.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 13:59:00 -0400
Message-Id: <1248199140.21343.17.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 10 msgs/h 3 sum rcpts/h 11 sum msgs/h 3 total rcpts 909 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: E70C38144792FA1E865B4C0445BF76BFAEBE2CE3
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 3 total 76 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 10:36 -0700, Ben Greear wrote:
> On 07/21/2009 10:12 AM, Trond Myklebust wrote:
> > On Tue, 2009-07-21 at 09:49 -0700, Ben Greear wrote:
> >> On 07/21/2009 05:15 AM, Trond Myklebust wrote:
> >>
> >>> What does /var/lib/nfs/v4recovery look like on the server?
> >> The server was misconfigured, but I still think the client should
> >> behave better in this case.  If you cannot reproduce it, let me know
> >> and I can try to be more specific.  If you still want the v4recovery
> >> information, let me know and I'll send it.
> >
> > So how should the client behave, when a screwed up server allows it to
> > mount but starts returning illegal values for setclientid? The only
> > thing I can see we could do is to tell the user EINSANESERVER...
> 
> Well, it could just fail the mount and give up and not overly spam
> /var/log/messages in a tight loop perhaps?

This doesn't happen at mount time. It happens when you open a file.

Trond


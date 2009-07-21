Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZGURMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZGURMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZGURMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:12:23 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:41660 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbZGURMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:12:22 -0400
Subject: Re: Error mounting FC8 NFS server with 2.6.31-rc3 NFSv4 client.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
In-Reply-To: <4A65F184.5060802@candelatech.com>
References: <4A64EB1F.4000602@candelatech.com>
	 <1248178527.5222.0.camel@heimdal.trondhjem.org>
	 <4A65F184.5060802@candelatech.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 13:12:19 -0400
Message-Id: <1248196339.21343.8.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 902 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: D894F0F8DA40E8312A7647C40F1EE7433C90AD07
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 74 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 09:49 -0700, Ben Greear wrote:
> On 07/21/2009 05:15 AM, Trond Myklebust wrote:
> 
> >
> > What does /var/lib/nfs/v4recovery look like on the server?
> 
> The server was misconfigured, but I still think the client should
> behave better in this case.  If you cannot reproduce it, let me know
> and I can try to be more specific.  If you still want the v4recovery
> information, let me know and I'll send it.

So how should the client behave, when a screwed up server allows it to
mount but starts returning illegal values for setclientid? The only
thing I can see we could do is to tell the user EINSANESERVER...

Now, we _should_ fix the wretched NFS server so that it doesn't do NFSv4
mounts when there is no configured root partition. We _should_ also fix
the damned thing so that it doesn't return illegal values.

Trond


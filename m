Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZKJWOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZKJWOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZKJWOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:14:53 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:45712 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827AbZKJWOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:14:52 -0500
Subject: Re: sunrpc port allocation and IANA reserved list
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Chris Friesen <cfriesen@nortel.com>, netdev@vger.kernel.org,
       Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1257888720.2834.30.camel@achroite.uk.solarflarecom.com>
References: <4AF9A63B.6010101@nortel.com>
	 <1257875623.2834.19.camel@achroite.uk.solarflarecom.com>
	 <4AF9B2CF.6050305@nortel.com>
	 <1257884799.3044.7.camel@heimdal.trondhjem.org>
	 <4AF9D5D1.9040501@nortel.com>
	 <1257888720.2834.30.camel@achroite.uk.solarflarecom.com>
Content-Type: text/plain
Date: Wed, 11 Nov 2009 07:14:51 +0900
Message-Id: <1257891291.3044.50.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 9 sum msgs/h 2 total rcpts 1842 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: BF1DF1CA15BF5319724766B3A03F0D2A6DE271C0
X-UiO-SPAM-Test: remote_host: 198.95.226.230 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 38 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 21:32 +0000, Ben Hutchings wrote:
> On Tue, 2009-11-10 at 15:06 -0600, Chris Friesen wrote:
> > On 11/10/2009 02:26 PM, Trond Myklebust wrote: 
> > > Just use /proc/sys/sunrpc/{max,min}_resvport interface to restrict the
> > > range used to a safer one. That's what it is for...
> 
> Unless I'm much mistaken, that only affects in-kernel SunRPC users.

There shouldn't be that many non-kernel sunrpc users that require
privileged ports.

The exceptions I can think of are

      * the 'mount' program, if you are using the legacy binary mount
        interface. Use text mounts instead...
      * rpc.statd might also use privileged ports when booting the
        system when it needs to notify servers of the reboot. You can
        set that port number using the '-o' option.

Others? Do any of the NIS services require it?

Trond


Return-Path: <linux-kernel-owner+w=401wt.eu-S966501AbXEGUS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966501AbXEGUS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966308AbXEGUSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:18:25 -0400
Received: from 1wt.eu ([62.212.114.60]:2516 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966296AbXEGUSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:18:25 -0400
Date: Mon, 7 May 2007 22:18:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gmail is a bit too popular..
Message-ID: <20070507201821.GG943@1wt.eu>
References: <20070507145555.GG3883@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507145555.GG3883@mea-ext.zmailer.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 05:55:55PM +0300, Matti Aarnio wrote:
> In the  linux-kernel  -list subscribers domain popularity
> analysis I got following results:
> 
>    2101 gmail.com
>      49 googlemail.com
>      46 gmx.de
>      41 redhat.com
>      33 yahoo.com
>      23 suse.de
>      22 gmx.net
>      21 comcast.net
> 
> 
> The  gmail  is so popular, that with their somewhat rudimentary 
> inbound MTA software this kind of recipient masses take horrible
> time to feed in...  Mere 0.5-0.7 seconds per recipient, but..
> 
> So far we have tried to feed all recipients in one go per
> message - that is sending 2100  RCPT TO -lines in one swoop,
> and the system has taken some 15-25 minutes per message to
> feed it to gmail.  We are running the delivery 20 streams in
> parallel, so it isn't quite as bad as it sounds..
> 
> I do have one thing that gmail could enable to speed up the message
> delivery (a lot!) from VGER and other list delivery sources.
> That single magic needed thing is called "PIPELINING" support
> at gmail's inbound MX servers.  With suitably well behaving
> smtpserver it is really trivial to implement, all real difficult
> magic is at the sending side smtp client codes.

I suspect they behave like that on purpose to fight spam. If they
implemented pipelining, it wouldn't help them. Most probably they
can add whitelists to allow some known sources to reach them with
no slowdown. I hope someone at gmail will read and forward the
information so that gmail users can still be served when the load
increases. 12k mails in March and April are somewhat higher than
the usual 9-10k.

Willy


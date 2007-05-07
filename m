Return-Path: <linux-kernel-owner+w=401wt.eu-S934174AbXEGPEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbXEGPEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXEGPEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:04:06 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:60321 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbXEGPEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:04:05 -0400
Date: Mon, 7 May 2007 11:03:54 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Matti Aarnio <matti.aarnio@zmailer.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: gmail is a bit too popular..
In-Reply-To: <20070507145555.GG3883@mea-ext.zmailer.org>
Message-ID: <alpine.DEB.0.98.0705071101510.6512@sigma.j-a-k-j.com>
References: <20070507145555.GG3883@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 
> Once upon a time I implemented that thing for a trans-atlantic
> SMTP fanout feed -- message delivery time became slashed from
> hundreds of RTT delays to mere few..

How about some elitism here? Dedicate a certain number of streams to 
everything-except-gmail, so MTAs from the 21st century can get their mail 
faster, and set the rest on gmail-only. Slows down gmail and speeds up the 
rest?

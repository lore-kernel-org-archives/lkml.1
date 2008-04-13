Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbYDMIax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbYDMIax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYDMIap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:30:45 -0400
Received: from main.gmane.org ([80.91.229.2]:42305 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbYDMIao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:30:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Niels <zorglub_olsen@hotmail.com>
Subject: Re: Western Digital GreenPower drives and Linux
Followup-To: gmane.linux.ide
Date: Sun, 13 Apr 2008 10:30:28 +0200
Message-ID: <ftsgb5$qi0$1@ger.gmane.org>
References: <234148243@web.de> <200804112200.28854.tvrtko@ursulin.net> <170fa0d20804112019h73928c99paadcc363539fea9c@mail.gmail.com> <200804120811.12468.tvrtko@ursulin.net> <170fa0d20804120820x1eced1ebl47b6a2f6593ea029@mail.gmail.com> <170fa0d20804120856w786b625cv41af33072605dab7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 62.79.44.136.adsl.gl.tiscali.dk
User-Agent: KNode/0.10.9
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008 17:56, Mike Snitzer wrote:

[snip]
> 
> Turns out 'wdidle3 /R' on my drive reported:
> "Idle3 Timer is disabled"
> 
> I took no explicit action to disable it 6 months ago. It strikes me as
> odd that WD would disable the Idle3 timer in firmware given the whole
> "GreenPower" campaign but I was pleasantly surprised; others may be
> too...

A data point from me. I have two of these, sda is 400GB and has root, boot,
swap and home partitions, sdb is 1TB and has one big partition. They're in
my desktop machine, which is usually powered on in the morning and off in
the evening. It's two months old.

sda:

9 Power_On_Hours          0x0032   099   099   000    Old_age  
Always       -       785
12 Power_Cycle_Count       0x0032   100   100   000    Old_age  
Always       -       141
193 Load_Cycle_Count        0x0032   200   200   000    Old_age  
Always       -       144

sdb:

9 Power_On_Hours          0x0032   099   099   000    Old_age  
Always       -       749
12 Power_Cycle_Count       0x0032   100   100   000    Old_age  
Always       -       122
193 Load_Cycle_Count        0x0032   195   195   000    Old_age  
Always       -       17276


The last of these numbers seems fairly high, compared to what others in this
thread have reported, especially considering that the disk is quite new.


//Niels


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbYD2WLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbYD2WLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758803AbYD2WKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:10:20 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:38813 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757888AbYD2WKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:10:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wqvffoSHo8AJtm1nf3bmAiAi6vwhIh+bTrGO8CBqq2VZTIKJknJTkXy0N58jT5M5Gh5LaKSvF8kKy0kNQKtwxHcZYd5BEHG0jC0iBVeFCmtYmzwXmsvbAKUhmEDsJzGeumomiCsg8t81ymRr3Y7xQmgKEEOtDE9Ch3zqJ5BL+qA=  ;
X-YMail-OSG: _fZ1npIVM1lKAzGlCf56UOL_lHjen4pMM7xY9Rbs7nS4w4f9RkBEJAGKL2CtHetiuImcrcKkslCJiwvJ42S3bSyZe7bKtKV5pyGD1u65kkMx_BAqfSkfRFvN3qzSqlYC0o4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Tue, 29 Apr 2008 14:55:39 -0700
User-Agent: KMail/1.9.6
Cc: Trent Piepho <tpiepho@freescale.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <Pine.LNX.4.64.0804282202340.8286@t2.domain.actdsltmp> <1209472526.311.50.camel@moss.renham>
In-Reply-To: <1209472526.311.50.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804291455.39674.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008, Ben Nizette wrote:
> 4) Status quo.  Easy, efficient, potentially hard to discover which gpio
> you actually want.
> 
> My vote's for 1 or 4.  The first one is heavier but easier.  The last
> one will need something like the discussed file mapping ranges to gpios.

My vote is for #4 with a chip listing file.

I don't like the hacked names ... none of the other /sys/class/*/name
files on any of my systems use hacked names.  The entire motivation for
name hacking seems wrong to me, and by observation it's been rejected
for all other class names.

- Dave


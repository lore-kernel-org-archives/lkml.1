Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbXLaAbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbXLaAbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 19:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbXLaAaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 19:30:55 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:62224 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbXLaAaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:30:55 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+rUclS4hO2yE+axyTIHqnk
Message-ID: <4778382F.1030103@reed.com>
Date: Sun, 30 Dec 2007 19:30:39 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Richard Harman <richard@richardharman.com>
CC: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>, pharon@gmail.com,
       Rene Herman <rene.herman@keyaccess.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
References: <47765D11.2040903@reed.com>	<1198967334.5049.3.camel@iamer-laptop>	<4776F6A0.9010801@keyaccess.nl>	<1198979361.11150.2.camel@iamer-laptop>	<20071230121725.11d05099@linux360.ro>	<47780657.8020208@richardharman.com> <20071230231818.54877db8@linux360.ro> <47779EDA.8070408@richardharman.com>
In-Reply-To: <47779EDA.8070408@richardharman.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Richard Harman wrote:
>
>>> I think I may have a monkey wrench to throw into this, I finally got 
>>> around to testing the C1E patch, and the port80 patch.  End result: 
>>> port80 patch has zero effect on this laptop, and the C1E patch makes
>>> it stable.
>>>
>
Stating that your system is "stable" is not very definitive.   Does 
hwclock work when full Fedora 8 is running without the port80 patch, or 
have you disabled the uses of hwclock in your init and shutdown code?   
Have you set the hwclock setting to use the extremely dangerous 
"-directisa" option - which hides the problem because it avoids the port 
80 i/o?

Try compiling and running the test program port80.c a few times.   If 
your machine doesn't hang, it would be interesting to see the results it 
gives.

The C1E patch alone does not fix the port 80 problem several of us have 
observed.  what does dmidecode say for your motherboard vendor and model?



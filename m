Return-Path: <linux-kernel-owner+w=401wt.eu-S1161153AbXAZS1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161153AbXAZS1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161150AbXAZS1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:27:48 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:41605 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161153AbXAZS1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:27:47 -0500
X-BigFish: V
Message-ID: <45BA4884.4020205@am.sony.com>
Date: Fri, 26 Jan 2007 10:29:24 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Paul Mundt <lethal@linux-sh.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] init: support preset lpj value as config option
References: <45B7F5E2.4070800@am.sony.com>	<20070125021847.GA7609@linux-sh.org>	<45B8F5FB.6090704@am.sony.com> <20070126024411.4d4b6c2e.akpm@osdl.org>
In-Reply-To: <20070126024411.4d4b6c2e.akpm@osdl.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> i386 is missing CONFIG_CMDLINE support, and this architecture
>> is used in embedded.
> 
> So if we add CONFIG_CMDLINE we fix this problem and we bring i386 into line
> with other platforms.  It's all good.
> 
>>  I think many other x86 derivatives are
>> also missing .config-based command line support.  CELF has
>> worked to get patches submitted to fix this, but so far these
>> haven't been accepted.
> 
> You have?
> 
> <looks at inbox>
> 
> To whom?

Matt Mackall would know better than I.  He's the person
CELF hired to do this.  Here are some of the previous LKML
discussions around this issue:

http://lkml.org/lkml/2006/6/11/115

http://lkml.org/lkml/2006/7/31/208

Last time I talked to Matt about this (some time in
November, I believe), he said he had worked out a
solution agreeable to H. Peter Anvin, who had issues
with the original submission.  I'm not sure if that
latest solution was submitted to mainline or not.

Matt?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Electronics
=============================


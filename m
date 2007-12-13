Return-Path: <linux-kernel-owner+w=401wt.eu-S933969AbXLMWDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969AbXLMWDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932922AbXLMWDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:03:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59499 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbXLMWDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:03:12 -0500
Message-ID: <4761AC05.40807@zytor.com>
Date: Thu, 13 Dec 2007 14:02:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Remove all definitions with fastcall
References: <1197491364.21291.14.camel@brick>  <47605238.9020402@cfl.rr.com> <1197495102.21291.28.camel@brick> <47619F9F.1080502@cfl.rr.com> <4761A227.70809@zytor.com> <4761AA8E.8090308@cfl.rr.com>
In-Reply-To: <4761AA8E.8090308@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> H. Peter Anvin wrote:
>> Not just default, it's the only thing supported.
>>
>>     -hpa
> 
> What about va args?  IIRC, fastcall fell back to stdcall after using up 
> registers, so va args HAD to be cdecl.
> 

On i386 gcc disables regparm implicitly for varadic functions.

	-hpa

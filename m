Return-Path: <linux-kernel-owner+w=401wt.eu-S933709AbXLMV4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709AbXLMV4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762459AbXLMV4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:56:34 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:52969 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757390AbXLMV4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:56:33 -0500
Message-ID: <4761AA8E.8090308@cfl.rr.com>
Date: Thu, 13 Dec 2007 16:56:30 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Remove all definitions with fastcall
References: <1197491364.21291.14.camel@brick>  <47605238.9020402@cfl.rr.com> <1197495102.21291.28.camel@brick> <47619F9F.1080502@cfl.rr.com> <4761A227.70809@zytor.com>
In-Reply-To: <4761A227.70809@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Dec 2007 21:57:10.0181 (UTC) FILETIME=[1C461D50:01C83DD3]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15604.001
X-TM-AS-Result: No--8.011600-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Not just default, it's the only thing supported.
> 
>     -hpa

What about va args?  IIRC, fastcall fell back to stdcall after using up 
registers, so va args HAD to be cdecl.


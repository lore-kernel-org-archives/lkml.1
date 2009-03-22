Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZCVRWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZCVRWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 13:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZCVRW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 13:22:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36508 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbZCVRWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 13:22:25 -0400
Date: Sun, 22 Mar 2009 18:22:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
Message-ID: <20090322172217.GA22639@elte.hu>
References: <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <20090322150917.GA17815@elte.hu> <49C6719B.2020303@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C6719B.2020303@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> btw, we have a ton of section warnings:
>>   
>
> Do you think its related to the brk changes, or is it just a general  
> observation?

last entry seemed to be related to the brk patches:

> WARNING: vmlinux.o(.text+0x6a288e): Section mismatch in reference from
> the function dmi_alloc() to the function .init.text:extend_brk()
> The function dmi_alloc() references
> the function __init extend_brk().
> This is often because dmi_alloc lacks a __init annotation or the
> annotation of extend_brk is wrong.

most of them are not.

	Ingo

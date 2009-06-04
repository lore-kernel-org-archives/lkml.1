Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbZFDRHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbZFDRHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZFDRHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:07:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbZFDRHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:07:41 -0400
Date: Thu, 4 Jun 2009 10:07:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Michael S. Zick" <lkml@morethan.org>
cc: Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
In-Reply-To: <alpine.LFD.2.01.0906040948480.4880@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com> <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain> <200906041121.30845.lkml@morethan.org>
 <alpine.LFD.2.01.0906040948480.4880@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Side note: is it more stable if you disable the VIA speedstep thing 
(whatever it's called (ok, google tells me it's called "TwinTurbo" and 
"Advanced PowerSaver")?

Features like that easily put a huge stress on power regulators etc, if 
they result in sudden changes in current draw.  Underspecced capacitors 
etc can cause CPU "brown-outs", which in turn can easily cause total 
failure. 

		Linus

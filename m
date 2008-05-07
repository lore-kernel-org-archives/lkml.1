Return-Path: <linux-kernel-owner+w=401wt.eu-S1764003AbYEGHZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764003AbYEGHZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbYEGHZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:25:23 -0400
Received: from www.tglx.de ([62.245.132.106]:55715 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbYEGHZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:25:20 -0400
Date: Wed, 7 May 2008 09:22:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: monstr@seznam.cz
cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 24/56] microblaze_v2: time support
In-Reply-To: <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
Message-ID: <alpine.LFD.1.10.0805070921090.3318@apollo.tec.linutronix.de>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu> <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu> <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu> <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu> <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu> <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu> <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu> <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu> <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, monstr@seznam.cz wrote:
> From: Michal Simek <monstr@monstr.eu>

> +int do_settimeofday(struct timespec *tv)
> +void do_gettimeofday(struct timeval *tv)

Again, please convert the time code to clocksource and use the generic
functionality.

Thanks,
	tglx

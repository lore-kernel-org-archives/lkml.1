Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYECUCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYECUCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 16:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYECUCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 16:02:39 -0400
Received: from www.tglx.de ([62.245.132.106]:55490 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbYECUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 16:02:38 -0400
Date: Sat, 3 May 2008 22:01:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stas Sergeev <stsp@aknet.ru>
cc: Ingo Molnar <mingo@elte.hu>, Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael-lists@free-electrons.com>
Subject: Re: [patch][resend] pcspkr: fix dependancies
In-Reply-To: <481C51BE.5010606@aknet.ru>
Message-ID: <alpine.LFD.1.10.0805032200080.6003@apollo.tec.linutronix.de>
References: <481C51BE.5010606@aknet.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, Stas Sergeev wrote:
> 
> Ingo, would it be possible to get that
> applied?

The input changes need to go via Dimitry, the x86 part can go in the
same commit.

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
> fix pcspkr dependancies: make the pcspkr platform
> drivers to depend on a platform device, and
> not the other way around.
> 
> Signed-off-by: Stas Sergeev <stsp@aknet.ru>
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> CC: Vojtech Pavlik <vojtech@suse.cz>
> CC: Michael Opdenacker <michael-lists@free-electrons.com>
> CC: Takashi Iwai <tiwai@suse.de>
> 

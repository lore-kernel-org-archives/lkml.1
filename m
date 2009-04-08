Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbZDHA4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbZDHA4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbZDHA4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:56:21 -0400
Received: from www.tglx.de ([62.245.132.106]:49732 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbZDHA4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:56:20 -0400
Date: Wed, 8 Apr 2009 02:56:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Identifying Intel Atom Z500PT
In-Reply-To: <20090407222144.GU5367@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0904080251540.21577@localhost.localdomain>
References: <20090407222144.GU5367@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009, Robert Schwebel wrote:

> Does anyone have an idea how to properly identify an Atom Z500PT cpu?
> The get_model_name() mechanics in arch/x86/kernel/cpu/common.c uses
> cpuid() to find out about the brand id, which is "Genuine Intel(R) CPU"
> with family 6 and model 28.

AFAICT cpuid() is the way to get the model name. If it returns
"Genuine Intel(R) CPU" then the kernel merily prints that info.

Consult your board vendor / BIOS tinkerer^Wdeveloper

Thanks,

	tglx

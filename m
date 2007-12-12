Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbXLLMgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbXLLMgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 07:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXLLMgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 07:36:06 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:55026 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXLLMgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 07:36:05 -0500
Date: Wed, 12 Dec 2007 13:35:21 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: linux@horizon.com
Cc: linux-kernel@vger.kernel.org, rene.herman@gmail.com, linux@horizon.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071212133521.2210ca7f@fastwebnet.it>
In-Reply-To: <20071212112049.17891.qmail@science.horizon.com>
References: <20071212112049.17891.qmail@science.horizon.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Dec 2007 06:20:49 -0500
linux@horizon.com wrote:

> With -O2, the cycle counts come out (before division) as
> out: 0xFFFFFFFFFFEA6F4F
> in:  0xFFFFFFFFFCE68BB6
> I think the "A" constraint doesn't work quite the same in
> 64-bit code.  The compiler seems to be using %rdx rather than
> %edx:%eax.

In another message he says to compile it with "-m32"  :)

-- 
	Paolo Ornati
	Linux 2.6.24-rc5-g4af75653 on x86_64

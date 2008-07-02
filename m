Return-Path: <linux-kernel-owner+w=401wt.eu-S1762917AbYGBHhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762917AbYGBHhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbYGBHh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:37:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:59385 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759894AbYGBHhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:37:24 -0400
Cc: linux-kernel@vger.kernel.org, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org
Message-Id: <B953B5BE-BB24-4656-9F13-7A8228D893E3@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Nye Liu <nyet@mrv.com>
In-Reply-To: <20080627200100.GA16661@mrv.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Re: [PATCH] POWERPC CPM: Minor cosmetic changes to udbg_putc
Date: Wed, 2 Jul 2008 02:37:09 -0500
References: <20080627200100.GA16661@mrv.com>
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 27, 2008, at 3:01 PM, Nye Liu wrote:

> From: Nye Liu <nyet@mrv.com>
>
> udbg_putc is a *function pointer* that is initialized during
> udbg_init_cpm. It might not be initialized properly when called from
> udbg_putc_cpm(), so (recursively) call udbg_putc_cpm() directly.
>
> Printing an "X" on initialization is ugly. How about a "\n" instead?
>
> Signed-off-by: Nye Liu <nyet@mrv.com>
>
> ---

Applied.  I removed the "\n" per Scott's feedback.

- k

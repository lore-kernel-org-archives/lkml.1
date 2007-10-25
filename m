Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbXJYJde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbXJYJde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbXJYJd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:33:27 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:54098 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754030AbXJYJd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:33:26 -0400
Date: Thu, 25 Oct 2007 11:32:40 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: "Dan Williams" <dan.j.williams@intel.com>,
       "Shannon Nelson" <shannon.nelson@intel.com>,
       linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       kernel@avr32linux.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] DMA: Correct invalid assumptions in the Kconfig text
Message-ID: <20071025113240.466b69ba@siona>
In-Reply-To: <20071024201616.02f87b20@siona>
References: <1193218705-16685-1-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20710240855j7bf1f0a6qa1d11af3a12910e5@mail.gmail.com>
	<20071024201616.02f87b20@siona>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 20:16:16 +0200
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> [handwaving about API extensions]

Oh, and we definitely need a way to report errors. Looks like the
existing drivers want this as well -- I couldn't help but notice this
in the iop-adma driver:

static irqreturn_t iop_adma_err_handler(int irq, void *data)
{
	(...)

	BUG();
}

That's a panic waiting to happen, isn't it?

Håvard

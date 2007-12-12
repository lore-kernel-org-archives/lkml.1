Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbXLLPyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbXLLPyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbXLLPx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:53:58 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:50840 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbXLLPx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:53:57 -0500
Message-ID: <47600350.3020000@keyaccess.nl>
Date: Wed, 12 Dec 2007 16:50:40 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <475FA060.6070004@gmail.com> <4af2d03a0712120325n50d057baq7ec440c5e57fda39@mail.gmail.com>
In-Reply-To: <4af2d03a0712120325n50d057baq7ec440c5e57fda39@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 12:25, Jiri Slaby wrote:

Thanks for reporting! You have two results that are somewhat off:

> Intel(R) Core(TM)2 Duo CPU E6850 @ 3.00GHz
> cycles: out 6500, in 3135

6500 / 3000 = 2.17. Fairly high...

> Intel(R) Xeon(R) CPU E5335 @ 2.00GHz
> cycles: out 3217, in 1898

3217 / 2000 = 1.61. Okay.

> Dual Core AMD Opteron(tm) Processor 275
> cycles: out 5508, in 5524

2200 MHz right?

5508 / 2200 = 2.50. Very high.

Nothing was dozing off in some ACPI sleep state or something?

Rene.

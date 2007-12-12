Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbXLLPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbXLLPz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbXLLPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:55:17 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:28371 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbXLLPzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=BvBRWmHHkvBv8ZzR/jLdvxCAiXFV/bdJAa/Q/Z/iVZdTufo2vtRx2eHrFH9nUO+xYkfQnGuD3taAJ43hhe7qcH9/7s4yvsEuh4OCNZ940ZfIFfTy2sWWeTiJRhdSKrCDZnwftamNi/5MSjmQKI9Tv8DLTSKnlNdi1wcCDusy6Z4=
Message-ID: <4760040B.9000805@keyaccess.nl>
Date: Wed, 12 Dec 2007 16:53:47 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <475FA060.6070004@gmail.com> <4af2d03a0712120325n50d057baq7ec440c5e57fda39@mail.gmail.com>
In-Reply-To: <4af2d03a0712120325n50d057baq7ec440c5e57fda39@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
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

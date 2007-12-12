Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbXLLLNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbXLLLNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbXLLLNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:13:31 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:3148 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbXLLLNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:13:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jNly5lYV1pt4aqHoi1xzUzKi/jHm1tp+HTmfgc97SGQguE/YoOWydQYIndG+S3E8gImSymykuTC4doO+ez1ck9Q1M9RPyzDFlvHA0JCSTjnmm7y2dw41JHl1xtr8qrSLve+trNxooja5f/lg275TLjmKBMsNY3awc+5PE5/GmVI=
Message-ID: <cabda6420712120313t339fb5ccv9e8aebcbf75c7817@mail.gmail.com>
Date: Wed, 12 Dec 2007 12:13:28 +0100
From: chri <chripell@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] netmos 9855 fix
Cc: linux-kernel@vger.kernel.org, "Thomas Richter" <thor@math.tu-berlin.de>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Martin Schitter" <ms@gewi.kfunigraz.ac.at>
In-Reply-To: <20071212011625.598654e9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11968504473036-git-send-email-chripell@gmail.com>
	 <20071212011625.598654e9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 10:16 AM, Andrew Morton <akpm@linux-foundation.org> wrote:

> What was wrong with it?
>

Hi,

on loading only one serial port was present and it wasn't working.
After looking in the data sheet I realized that the base address was
wrong. For further reference here is lspci and relevant dmesg output:

02:00.0 Communication controller: NetMos Technology PCI 9855 Multi-I/O
Controller (rev 01) (prog-if 02)
        Subsystem: LSI Logic / Symbios Logic Unknown device 0022
        Flags: medium devsel, IRQ 19
        I/O ports at df00 [size=8]
        I/O ports at de00 [size=8]
        I/O ports at dd00 [size=8]
        I/O ports at dc00 [size=8]
        I/O ports at db00 [size=8]
        I/O ports at da00 [size=16]

parport1: PC-style at 0xdd00 [PCSPP,TRISTATE]
parport2: PC-style at 0xdf00 [PCSPP,TRISTATE,EPP]
0000:02:00.0: ttyS0 at I/O 0xdb00 (irq = 19) is a 16550A
0000:02:00.0: ttyS1 at I/O 0xda00 (irq = 19) is a 16550A



-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."

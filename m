Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbXKRFbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbXKRFbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 00:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbXKRFb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 00:31:29 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:49267 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbXKRFb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 00:31:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=smtjbb3DLPl9/ecB7CpHbJyWjPh65kWMy6v+wPqknaB+XPrAg0/qTTbcRUzoUkKZ+cAkg2ZGyiqc1JheMCvhYfIeImEp1z2X22Qncth7f90vKTezaJ33dgXthEYbUdgs2zJkR1mxOBHagP/bglstx8LW0iHZT7Xv60PGYGRuX3A=
Message-ID: <f69849430711172131j41c21d84y2ac10759eff29eb7@mail.gmail.com>
Date: Sat, 17 Nov 2007 21:31:25 -0800
From: "kernel coder" <lhrkernelcoder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: increased number of cycles
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
        I'm trying to add some code to netif_receive_skb function in
dev.c file . The cycles consumed by that code was around 16 cycles on
Dual Core Opetron machine.I'm working on that code for last 6 months
now and the consumed cycles have always been around 16 cycles .I don't
touch any other part of kernel .

But for last 4 days the consumed cycles have suddenly increased to
around 35 cycles . I'm using RDTSC instruction to profile the
code.There is no change in code and the kernel version is also the
same .I am assuming that there  must be something wrong with hardware.

Please guide me how can i figure out the root cause.What areas should
i look at to find out the reason for increased number of cycles.I
don't think that there is any issue in kernel because the kernel
version and code  is same    . Can the the log messages during system
bootup help me to diagnose the problem


shahzad

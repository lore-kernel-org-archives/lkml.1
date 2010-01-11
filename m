Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281Ab0AKKz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0AKKz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705Ab0AKKzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:55:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42325 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751030Ab0AKKzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:55:55 -0500
Date: Mon, 11 Jan 2010 10:59:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Erik Rigtorp <erik@rigtorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Monitoring file descriptors without switching context
Message-ID: <20100111105937.27d2a830@lxorguk.ukuu.org.uk>
In-Reply-To: <a57051ba1001110229q2ca28ffbqea37d07735debb52@mail.gmail.com>
References: <a57051ba1001110229q2ca28ffbqea37d07735debb52@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I really need is some way to have the hardware block and monitor
> IO for me. Would it be feasible to implement a special low latency
> poll() syscall that uses MONITOR/MWAIT instructions to monitor file
> descriptors?

The futex locks are probably the lowest level interface you've got for
interlocking between tasks and are very fast. You can also pin tasks to
groups of cpus so you can create an I/O only core for example.

Alan

Return-Path: <linux-kernel-owner+w=401wt.eu-S935148AbZLMBze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148AbZLMBze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935049AbZLMBzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:55:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53508 "HELO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S935052AbZLMBzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:55:18 -0500
Date: Sat, 12 Dec 2009 13:50:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cypher Wu <cypher.w@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Questions about Watch Dog Timer under Linux.
Message-ID: <20091212135035.0d01018d@lxorguk.ukuu.org.uk>
In-Reply-To: <f9f38a550912111946w665b267dkc42d184bdc437d02@mail.gmail.com>
References: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
	<20091209145919.GH9018@sirena.org.uk>
	<f9f38a550912110027r70710867k3a08c6d5913ce13@mail.gmail.com>
	<20091211102159.GB18825@rakim.wolfsonmicro.main>
	<f9f38a550912111946w665b267dkc42d184bdc437d02@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> timer. This type of WDT is widely used in our embedded systems and we
> usually install a callback in timer interrupt to clearing WD before
> BSP starting the RTOS kernel, and then starting a task to clear WD and
> uninstall the callback.
> I'm wonder when cope with that type of WD, is there any framework
> already in the Linux kernel and booter, or I've to modify them by
> myself?

Without knowing which boot environment you are using I don't know. For
the kernel itself you may need to touch the timer early on in boot (in
your platform setup code), then set up the driver early on.

There isn't a general framework for this although there may be one I
don't know about implemented in some other specific platform.

Alan

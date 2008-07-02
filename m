Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbYGBF0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbYGBF0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 01:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYGBF0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 01:26:37 -0400
Received: from [194.117.236.238] ([194.117.236.238]:55180 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbYGBF0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 01:26:37 -0400
Date: Wed, 2 Jul 2008 08:25:55 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>
Subject: Re: dsdt buggy acpi
Message-ID: <20080702082555.0959ef2b@linux360.ro>
In-Reply-To: <dd18b0c30807010918p48cfbe2bnb7e4a2bf00a01638@mail.gmail.com>
References: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com>
	<200807011619.53339.rjw@sisk.pl>
	<dd18b0c30807010918p48cfbe2bnb7e4a2bf00a01638@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 16:18:45 +0000
"Justin Mattock" <justinmattock@gmail.com> wrote:

> Cool; thanks.
> I'll check that out and see where and how I can locate the dsdt
> manufacture number,  then see if I can fix the broken dsdt error and
> apply this to the kernel and see what happens.
> regards;

Just one note here: DSDTs have nothing to do with the kernel. This is
just broken firmware. The most one can do _in-kernel_ is blacklist some
functionality or create a workaround, but this only happens for widely
used stuff. Broken DSDTs aren't widely used stuff, they are written by
the machine's vendor (the laptop's manufacturer for example, but this
could be different for desktops) and differ a lot from one machine to
another.


	Eduard

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbXEQJCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbXEQJCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbXEQJC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:02:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41121 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754974AbXEQJC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:02:26 -0400
Date: Thu, 17 May 2007 10:07:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Anand Jahagirdar" <anandjigar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fork bombing Attack
Message-ID: <20070517100703.01577558@the-village.bc.nu>
In-Reply-To: <25ae38200705170025m23fe8ea9s81515ec8d1a0a137@mail.gmail.com>
References: <25ae38200705170025m23fe8ea9s81515ec8d1a0a137@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 12:55:53 +0530
"Anand Jahagirdar" <anandjigar@gmail.com> wrote:

> Dear Sir,
>              I just want to know whether fork bombing attack still
> exist on the machine having Distribution as Fedora Core 6 and Linux
> Kernel 2.6.x.?
> 
>            additional Info :  I have set ulimit as 8000 and loged in
> as Guest User on machine having Distribution as Fedora Core 6 and
> Linux kernel 2.6.18. simple fork bombing program while(1) fork();
> killed the box and machine needed reboot. will any body please tell me
> why fork bombing attack killed the box even after setting ulimit as
> 8000?

Did you set a sensible per user process limit and what swap/memory setup
do you have. If you have sensible per user process limits and zero
overcommit setup you shouldn't be able to do anything beyond soak up a
lot of CPU time.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXJYDJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXJYDJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXJYDJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:09:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58754 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXJYDJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:09:40 -0400
Date: Wed, 24 Oct 2007 20:06:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Zurk Tech" <zurktech@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
Message-ID: <20071024200619.26130f62@laptopd505.fenrus.org>
In-Reply-To: <2ed59cbb0710242002r7ff3ab89k2b22582fc1de9d2c@mail.gmail.com>
References: <2ed59cbb0710242002r7ff3ab89k2b22582fc1de9d2c@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 23:02:14 -0400
"Zurk Tech" <zurktech@gmail.com> wrote:

> Hi guys,
> I have a tyan s3992 h2000 with single barcelona amd quad core cpu (the
> other cpu socket is empty). cat /proc/cpuinfo shows amd quad core
> processor
> but core : 1....ive compiled the kernel from scratch with smp and
> amd64 + the numa stuff. i also tried debian etchs amd64 smp kernel and
> same result.
> is amd barcelona quad core cpu not yet supported or is it something
> else ? Thanks for any insight. im completely stumped. ive dealt with
> mutliprocessing machines before and have a couple of dual cores which
> are fine with the
> exact same kernel configs. my amd tk-53 x2 turions show 2 cores in
> cpuinfo.... -Zurk-

Hi,

this sort of issue is usually best diagnosed when we can get to see the
dmesg output... since quite often the kernel will note errors and
warnings there that will give a clue of what is going on. Would you
mind attaching your dmesg on the broken machine to a mail ?

Greetings,
   Arjan van de Ven

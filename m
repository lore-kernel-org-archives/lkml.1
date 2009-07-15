Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbZGOJdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbZGOJdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZGOJdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:33:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58740 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752546AbZGOJdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:33:49 -0400
Date: Wed, 15 Jul 2009 10:34:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: ykzhao <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu,
       Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: [PATCH] Solve the issue with memory corruption on Intel BIOS.
Message-ID: <20090715103431.4381b423@lxorguk.ukuu.org.uk>
In-Reply-To: <1247637314-5609-1-git-send-email-bug-track@fisher-privat.net>
References: <1247637314-5609-1-git-send-email-bug-track@fisher-privat.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 07:55:14 +0200
Alexey Fisher <bug-track@fisher-privat.net> wrote:

> In Bug 13710 was reported "corrupted low memory after resume on Intel
> DG45ID board". It use AMI BIOS with Intel vendor string. We need to add this
> vendor to CONFIG_X86_RESERVE_LOW_64K workaround.

Given that this is the first report of a problem with an Intel BIOS, and
there are millions of systems not affected your match is far too wide I
think. Match the board identifier as well at least rather than randomly
making everyone suffer.


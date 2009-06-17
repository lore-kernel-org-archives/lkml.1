Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbZFQO1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbZFQO1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbZFQO12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:27:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49614 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764769AbZFQO11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:27:27 -0400
Date: Wed, 17 Jun 2009 15:28:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]io_apic.c: fix compile warning
Message-ID: <20090617152846.72804bae@lxorguk.ukuu.org.uk>
In-Reply-To: <1245248720.3312.27.camel@myhost>
References: <1245248720.3312.27.camel@myhost>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 22:25:20 +0800
"Figo.zhang" <figo1802@gmail.com> wrote:

> fix compile warning:
> arch/x86/kernel/apic/io_apic.c: In function ‘ioapic_write_entry’:
> arch/x86/kernel/apic/io_apic.c:466: warning: ‘eu’ is used uninitialized in this function
> arch/x86/kernel/apic/io_apic.c:465: note: ‘eu’ was declared here

What compiler are you using. Current gcc correctly notices that there are
no uninitialized things to worry about ?

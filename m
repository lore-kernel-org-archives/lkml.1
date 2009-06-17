Return-Path: <linux-kernel-owner+w=401wt.eu-S932877AbZFQOff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbZFQOff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbZFQOf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:35:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41632 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbZFQOf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:35:26 -0400
Subject: Re: [PATCH]io_apic.c: fix compile warning
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: "Figo.zhang" <figo1802@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <bb33bcf20906170729n616dcdbfkc02a168347612138@mail.gmail.com>
References: <1245248720.3312.27.camel@myhost>
	 <20090617152846.72804bae@lxorguk.ukuu.org.uk>
	 <bb33bcf20906170729n616dcdbfkc02a168347612138@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Wed, 17 Jun 2009 20:05:22 +0530
Message-Id: <1245249322.4870.19.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 17 Jun 2009 22:25:20 +0800
> "Figo.zhang" <figo1802@gmail.com> wrote:
> 
> > fix compile warning:
> > arch/x86/kernel/apic/io_apic.c: In function ‘ioapic_write_entry’:
> > arch/x86/kernel/apic/io_apic.c:466: warning: ‘eu’ is used uninitialized in this function
> > arch/x86/kernel/apic/io_apic.c:465: note: ‘eu’ was declared here
> 
> What compiler are you using. Current gcc correctly notices that there are
> no uninitialized things to worry about ?

Even 4.4.0 and above reports this warning. Last time i remember it
generated somewhere around 70 such warnings. And, then you need to dig
down whether any of them will really introduce bug(s). Else, leave as it
is. It is more of a gcc problem rather than kernel.

Regards--
Subrata



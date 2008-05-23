Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbYEWST7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbYEWST7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYEWSTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:19:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56677 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786AbYEWSTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:19:46 -0400
Date: Fri, 23 May 2008 11:18:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Robert Richter" <robert.richter@amd.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Enable mmconf access to PCI ECS for all AMD fam10h systems
Message-ID: <20080523111825.580423e1@infradead.org>
In-Reply-To: <86802c440805231057v659e5c7ahfd0407d46ef34bfd@mail.gmail.com>
References: <20080523124622.GV27511@erda.amd.com>
	<86802c440805231057v659e5c7ahfd0407d46ef34bfd@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 10:57:22 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Fri, May 23, 2008 at 5:46 AM, Robert Richter
> <robert.richter@amd.com> wrote:
> > Yinghai,
> >
> > We would like to enable ECS for all fam10h systems. What was the
> > reason for patch 5f0b2976 that enables it for Sun systems only? If
> > there are no objections, this patch should be reverted.
> 
> Someone express the concern about touching MSR. Arjan or Andi?
> 
> for those of system that doesn't have MCFG table there, they could use
> pci=check_enable_amd_mmconf to enable it forcely.

using MMIO if the bios doesn't allow it via MCFG is a huge mistake and
shouldn't be done.

Using the extended port IO version is actually perfectly reasonable to
me and I would encourage that to be in the kernel (and be used in favor
of MCFG if the port IO method is there)


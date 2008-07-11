Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYGKKVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYGKKVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYGKKVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:21:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54503 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYGKKVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:21:16 -0400
Date: Fri, 11 Jul 2008 12:22:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/pci: patches for tip/x86/unify-pci
Message-ID: <20080711102205.GA22725@uranus.ravnborg.org>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com> <20080710171721.GA19737@elte.hu> <20080710181234.GA32174@elte.hu> <20080710195249.GB17255@uranus.ravnborg.org> <20080710195425.GB23322@elte.hu> <20080711082042.GT7963@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711082042.GT7963@erda.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > So if I am not mistaken you can kill pci-y entirely:
> 
> Yes, but...
> 
> > > 
> > > obj-y                           := fixup.o
> 
> ... this is with a plus:
> 
> obj-y                           += fixup.o

obj-y is empty when you enter the Makefile.
So if you start out with ':=' or '+=' is no difference.

	Sam

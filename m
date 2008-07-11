Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYGKK2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYGKK2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYGKK14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:27:56 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52469 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbYGKK1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:27:55 -0400
Date: Fri, 11 Jul 2008 12:28:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/pci: patches for tip/x86/unify-pci
Message-ID: <20080711102844.GB22725@uranus.ravnborg.org>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com> <20080710171721.GA19737@elte.hu> <20080710181234.GA32174@elte.hu> <20080710195249.GB17255@uranus.ravnborg.org> <20080710195425.GB23322@elte.hu> <20080711082042.GT7963@erda.amd.com> <20080711102205.GA22725@uranus.ravnborg.org> <20080711102310.GA17033@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711102310.GA17033@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > obj-y is empty when you enter the Makefile.
> > So if you start out with ':=' or '+=' is no difference.
> 
> i guess it's safer to use +=, because it's ordering invariant.
> 
> We should use := only if we absolutely want to override the current 
> rules.

In the past I was carefully to use ':=' for the first assignmnet so the
variable was a " simply expanded variables" variable.
But as I have added a 'obj-y := ' in kbuild we should
be safe.

" simply expanded variables" is some special make stuff.

A typical:

FOO = bar

is a "recursively expanded variable".
Here the assingment is evaluated on each usage.

	Sam

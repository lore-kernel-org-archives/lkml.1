Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYCCU5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYCCU5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYCCU4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:56:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:17828 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbYCCU4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:56:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Dgx0wh+zuaqNJLpgo0kZFMAAOz8efR0K1VHRkE4Q4BWpx8oqJ8wnFr3hED7kiD/uH3QUBSrFDsmdIP5yJ/wKf2dE/aRrcKUgxqbnFG72ajpCll+lVXvJmaEbyi6axB8bWn5UlVxEXZOX4NdOjVsXZo6iM67Qa9vYrmCZUz3WG+A=
Subject: Re: [PATCH] x86: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47CC6422.5030806@qumranet.com>
References: <1204573043.3266.50.camel@brick> <47CC6422.5030806@qumranet.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 12:56:42 -0800
Message-Id: <1204577802.22933.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 22:48 +0200, Avi Kivity wrote:
> Harvey Harrison wrote:
> > __FUNCTION__ is gcc-specific, use __func__
> >
> >   
> 
> Which is shorter too.
> 
> >  arch/x86/kvm/lapic.c          |    8 ++++----
> >  arch/x86/kvm/mmu.c            |   34 +++++++++++++++++-----------------
> >  arch/x86/kvm/paging_tmpl.h    |   14 +++++++-------
> >  arch/x86/kvm/svm.c            |   12 ++++++------
> >  arch/x86/kvm/vmx.c            |    6 +++---
> >  arch/x86/kvm/x86.c            |   10 +++++-----
> >   
> 
> Please send the kvm parts against kvm.git instead of mainline to avoid 
> needless merges.

Sure, I'll send a split out patch against kvm.git

Ingo, do you mind chopping the diff to apply just the x86-specific stuff
or do you want a split patch as well?

Harvey


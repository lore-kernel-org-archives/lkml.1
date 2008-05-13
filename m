Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYEMLsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYEMLsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYEMLsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:48:32 -0400
Received: from gw.goop.org ([64.81.55.164]:35669 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYEMLsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:48:31 -0400
Message-ID: <48298002.5080300@goop.org>
Date: Tue, 13 May 2008 12:48:18 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Robert Kaiser (FH)" <kaiser@informatik.fh-wiesbaden.de>
CC: xen-devel@lists.xensource.com, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: remove support for non-PAE 32-bit
References: <48243015.2010801@goop.org> <20080513110822.GA1679@elte.hu> <200805131332.14631.kaiser@informatik.fh-wiesbaden.de>
In-Reply-To: <200805131332.14631.kaiser@informatik.fh-wiesbaden.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Kaiser (FH) wrote:
> Hmm, I had to revert to non-PAE operation (using xen 3.2.1) recently in order 
> to get Xen to run under qemu. Does anyone know of another work-around to run 
> Xen/Linux under qemu?

In principle it should work in PAE mode; it certainly works in kvm.  
What problem are you seeing?  I think there's a bug in qemu's x86 
emulation with respect to mis-reporting the eip of an xchg which faults, 
which may be what you're seeing.

    J


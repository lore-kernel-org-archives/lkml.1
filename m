Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbYETXN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbYETXN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYETXNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:13:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54571 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYETXNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:13:50 -0400
Date: Wed, 21 May 2008 00:13:23 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Javier Herrero <jherrero@hvsistemas.es>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Bryan Wu <cooloney@kernel.org>
Subject: Re: b4aa54d951d38d7a989d6b6385494ef5ea7371d7 breaks some serial configurations
Message-ID: <20080520231323.GA10750@flint.arm.linux.org.uk>
References: <20080520073556.GA1090@flint.arm.linux.org.uk> <483286AF.2090302@hvsistemas.es> <20080520083217.GA10172@flint.arm.linux.org.uk> <4832AD84.6090300@hvsistemas.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4832AD84.6090300@hvsistemas.es>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 12:52:52PM +0200, Javier Herrero wrote:
> I see... would be OK to move the asm/serial.h include to its original 
> position and to modify the asm-blackfin/serial.h in this way to avoid 
> duplicate definition warnings, or would it be too ugly?:

Can blackfin systems accept PCMCIA cards?  Or PCI cards?  In which case
you probably don't want to implement this support like this.

A better solution may be to add some UPF_ flags to indicate the interrupt
polarity on a per-port basis.  Not sure I'm particularly thrilled by that
idea though, but other solutions I can think of inspire me even less.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

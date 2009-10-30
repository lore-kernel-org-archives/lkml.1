Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbZJ3Kad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbZJ3Kad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 06:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbZJ3Kac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 06:30:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57715 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756842AbZJ3Kac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 06:30:32 -0400
Date: Fri, 30 Oct 2009 10:32:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] binfmt_elf: FatELF support for kernel modules.
Message-ID: <20091030103214.463042fb@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.0910292224560.4219@andre.icculuslan>
References: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan>
	<4ADD0086.9060304@goop.org>
	<alpine.DEB.2.00.0910200043200.18342@andre.icculuslan>
	<4AE22D04.50708@goop.org>
	<20091024121421.2e530635@lxorguk.ukuu.org.uk>
	<4AE5F4FB.3000506@goop.org>
	<alpine.DEB.2.00.0910292224560.4219@andre.icculuslan>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Allows kernel modules to be FatELF binaries.
> 
> Details, rationale, tools, and patches for handling FatELF binaries can be
> found at http://icculus.org/fatelf/

And you still ignore the fundamental point that the kernel module search
path typically includes the architecture anyway so you can simply install
two module files. That makes this feature pointless.

NAK

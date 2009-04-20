Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZDTCJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZDTCJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 22:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZDTCI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 22:08:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:2061 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbZDTCI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 22:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bEExG4KU8q9hOwkdWTPNcXbdOzrxVkGpwhltM7Ye0gnCxmYEVBafd2OuSjLXf91wta
         VdF7o0yZPllmj1c0e0tzuSKJutvbb2aVJ1DZ5OQcSiPUnDbX/0nOLZ+Lcnt6nifp8EiX
         sBzvSWpZzcwT63/SHUoat1byImt2RlmbxwddM=
Message-ID: <49EBD934.4070909@gmail.com>
Date: Sun, 19 Apr 2009 20:08:52 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Hitoshi Mitake <h.mitake@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>	<adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>	<49EB9F59.4080904@zytor.com> <20090419223519.GA27706@elte.hu> <adaskk4ywf9.fsf@cisco.com>
In-Reply-To: <adaskk4ywf9.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > Also, atomicity might not be possible to guarantee on the bus level: 
>  > say the device sits on a 32-bit PCI bus. (No matter what instruction 
>  > the CPU gets, a readq/writeq there has to be done as two 32-bit bus 
>  > accesses.)
> 
> Well, the conventional PCI devices I know of with 64-bit registers were
> PCI-X cards, keyed so they would only fit into a 64-bit slot.  And of
> course there is no such thing as 32-bit PCI Express.

It's quite possible to use most 64-bit PCI-X cards in a 32-bit slot, 
with the 64-bit part of the card not plugged into anything. It's 
supposed to work (as long as the card can handle the voltage the slot uses).

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYBDPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYBDPaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYBDPaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:30:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:1894 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYBDPaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:30:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MUQGR65KVw5EmoootDwTfvqXYYOpxD1nQ2zM8KRDHQL5aO/TXeI+JsbfRebcbiXEC37aVdjSLhotsd0m03MnkB2UhnnmGLH6D6Je9T/z+Se34H4I7+mT6yt3EI1RqBXNN40hSPBmIutvXqBID60W50FCGYVFKN5/elbJ2QLitxY=
Message-ID: <b6a2187b0802040730y44580594i56b26ed0fcb8292e@mail.gmail.com>
Date: Mon, 4 Feb 2008 23:30:12 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Commit f06e4ec breaks vmware
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       petr@vandrovec.name, "Glauber de Oliveira Costa" <gcosta@redhat.com>
In-Reply-To: <20080204145311.GB13154@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr>
	 <20080204115144.GA17850@elte.hu>
	 <b6a2187b0802040601s76222435t306aef2059cbbb2b@mail.gmail.com>
	 <20080204145311.GB13154@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 4, 2008 10:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > commit 8d947344c47a40626730bb80d136d8daac9f2060
> > Author: Glauber de Oliveira Costa <gcosta@redhat.com>
> > Date:   Wed Jan 30 13:31:12 2008 +0100
> >
> >     x86: change write_idt_entry signature
>
> does the patch below ontop of x86.git#mm fix this?


> 32-bit or 64-bit guest kernel?

32-bit.

Yep, this fixed the problem.

You're amazingly fast!

Thank you,
Jeff.

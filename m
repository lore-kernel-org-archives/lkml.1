Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZDURUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZDURUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZDURT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:19:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZDURTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:19:55 -0400
Message-ID: <49EE0013.6010008@zytor.com>
Date: Tue, 21 Apr 2009 10:19:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>	<adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>	<adaws9gywkd.fsf@cisco.com> <49EBCDC0.1020001@zytor.com>	<20090420105304.GC6670@elte.hu>	<a6b9f31a0904200747x7e28a4e3if0be4fc0d87241c9@mail.gmail.com>	<20090420160332.GB9689@elte.hu>	<a6b9f31a0904210133m29e68580w1fb7a8e6159b65d6@mail.gmail.com>	<49EDE9E9.8090905@zytor.com> <adamyaavst5.fsf@cisco.com>
In-Reply-To: <adamyaavst5.fsf@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> 
> However I worry that this just leaves driver authors too much rope.
> Choosing readq_atomic() vs. readq() is just one more thing to get wrong.
> 

... as is having each driver implementing their own substitutes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


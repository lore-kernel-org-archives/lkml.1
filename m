Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492AbYIANRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbYIANRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYIANQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:16:57 -0400
Received: from www.tglx.de ([62.245.132.106]:59896 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYIANQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:16:56 -0400
Date: Mon, 1 Sep 2008 15:16:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Fleming <mattjfleming@googlemail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: ktime_set() does not check for nanoseconds > one second
In-Reply-To: <5ff4a1e50809010611x3d8940e0n282da0b1ec5b321b@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809011515060.3243@apollo.tec.linutronix.de>
References: <5ff4a1e50809010338o77fffec4w625ed48b3987d51@mail.gmail.com>  <alpine.LFD.1.10.0809011317460.3243@apollo.tec.linutronix.de>  <5ff4a1e50809010457l7051b7e8vc7f86d68ae42e529@mail.gmail.com>  <alpine.LFD.1.10.0809011501450.3243@apollo.tec.linutronix.de>
 <5ff4a1e50809010611x3d8940e0n282da0b1ec5b321b@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Matt Fleming wrote:

> 2008/9/1 Thomas Gleixner <tglx@linutronix.de>:
> >
> > Won't work with arbitrary numbers. i.e. >= 2* NSEC_PER_SEC. Looking at
> > it, I'm even less convinced that it is a good idea.
> >
> >      tglx
> >
> 
> Do you have another suggestion? Or should I just account for the >= 1
> sec case in the calling code?

If you use runtime generated nsec values, why don't you use
ktime_add_ns() and feed the nsec value into it ?

Thanks,

	tglx

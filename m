Return-Path: <linux-kernel-owner+w=401wt.eu-S1752236AbYANXQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752236AbYANXQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYANXPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:15:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:57047 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYANXPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=v8OluVzfNHf0ecO2gzjl854tUS1mjuqkCNYrurZtxgwvdoMW48c5pF/m3mqlqcxnI4L9IudwMerOpQzjBIVEdS88nEIg1c5eoDQ3raqQUCmzNo0UGco6YXv3Cbz/s76XQDbOAfPQulMs7hcK2KE00cFKPU0D2R4wBH9JeaFCQbw=
Date: Tue, 15 Jan 2008 00:13:51 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Tuomo Valkonen <tuomov@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080115001351.74465792@Varda>
In-Reply-To: <20080114161828.GO2310@csclub.uwaterloo.ca>
References: <20080112150621.GC6751@mit.edu>
	<20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
	<20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
	<20080113231150.GB23906@mit.edu>
	<20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
	<1200303743.24517.6.camel@tara.firmix.at>
	<slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi>
	<m3d4s4yb4s.fsf@maximus.localdomain>
	<20080114110328.GA29126@jolt.modeemi.cs.tut.fi>
	<m3myr8vakf.fsf@maximus.localdomain>
	<20080114161828.GO2310@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 14 Jan 2008 11:18:28 -0500
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) escribió:

> On Mon, Jan 14, 2008 at 01:46:56PM +0100, Krzysztof Halasa wrote:
> > Nothing will make it work reliably if the system clock isn't stable.
> 
> I remember my nforce2 board having totally insane clock behaviour back
> around 2.6.14/2.6.15 or so.  It has since been fixed in newer kernels.

 My experience too with a Uli 1697 based mb. Estrange clock behaviour with
kernel around .15-20 but fixed now (suffering too with ext3 fsck now i use jfs)

 Back in the day i blamed the new mb but now that it runs fine i can only blame
the kernel or ubuntu user space.

> I seem to recall some ATI chipsets were even more insane than the nvidia
> at the time, with some running double speed for the system time.
> 
> --
> Len Sorensen
> --

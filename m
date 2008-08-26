Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYHZQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYHZQku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbYHZQkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:40:43 -0400
Received: from mout2.freenet.de ([195.4.92.92]:54283 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134AbYHZQkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:40:42 -0400
Date: Tue, 26 Aug 2008 18:40:39 +0200
From: Gerhard Brauer <gerhard.brauer@web.de>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826164039.GB5300@tux1.brauer.lan>
References: <20080822065012.GV14110@elte.hu> <20080822113941.147a1db0@doriath.conectiva> <20080822153451.GA8390@Krystal> <20080822132948.57e47076@doriath.conectiva> <20080822163520.GA9860@Krystal> <20080822142054.403cbdef@doriath.conectiva> <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826130216.4d723b0a@doriath.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080826130216.4d723b0a@doriath.conectiva>
User-Agent: Mutt/1.5.18-muttng (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 01:02:16PM -0300, Luiz Fernando N. Capitulino wrote:
> Em Tue, 26 Aug 2008 16:18:51 +0200
> Gerhard Brauer <gerhard.brauer@web.de> escreveu:
> 
> | Some things i noticed:
> | - The system boots always when i either enable VT-x in guest settings or
> |   disable acpi and run the guest with acpi=off.
> 
>  Yes, lots of ubuntu users have reported the same but another "lots"
> of them have reported that the trick didn't work.

I must relativate above: i have two test enviroments, one is our
LiveCD/Install-ISO with 2.6.26 which we made special for a linux
conference last weekend (our official iso comes still with 2.6.25). With
this iso the "trick" with VT-x or noacpi works.
But on an installed archlinux (with distribution kernel 2.6.26) this
does'nt work. Sometimes it works when i restart the virtualbox
application, but mostly not. So on this installed guest system the only
working solution seems to add noreplace-paravirt as kernel parameter.
But this makes the system terrible slow (mostly on udev things).

I try Mathieu's hints currently by building a new distribution kernel
with the changes.
But i think the biggest problem to maybe solve this from the sight of
kernel devs is that we all have different "test" enviroments (vbox
versions, architectures, distribution kernels,...) where the oops (i
think) not appears for all on the same place.
On the other hand, the more we we try such patches in different
enviroments there is a better chance to get a real fix - from kernel dev
side or from virtualbox/Sun side...

>  Thanks for joining!
> Luiz Fernando N. Capitulino

Gerhard

-- 
www,archlinux.de

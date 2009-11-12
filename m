Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZKLV3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZKLV3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZKLV3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:29:32 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:42310 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbZKLV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:29:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ctv/rQvre6plbzRp8UIisVsF4y5D+i7nPnS0akk5ij5qFy9UwQLlnEJ3CfXGe5LMjF
         2+xxx6Sr8D9SO3a2V2uur82+RF9UdDYfz1trzMmh28JiHu33245wpyFIB2ecHOtlXOT5
         bo0ge6Re9Gzr13V3WmYWXHB1LTpzXh9re/aGY=
Date: Fri, 13 Nov 2009 00:29:35 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <andi@firstfloor.org>, Robert Hancock <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
Message-ID: <20091112212935.GE5728@lenovo>
References: <4AFACC03.7080209@mayc.ru> <4AFB2822.30906@gmail.com> <20091112021209.GA21625@khazad-dum.debian.net> <878web7kwf.fsf@basil.nowhere.org> <1258047454.16197.1344913359@webmail.messagingengine.com> <m3639flaet.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3639flaet.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 10:07:22PM +0100, Krzysztof Halasa wrote:
> "Henrique de Moraes Holschuh" <hmh@hmh.eng.br> writes:
> 
> > In this case, the problem seems to be access over /dev/mem to stuff the
> > kernel is already taking care of.
> 
> Not sure if local APIC counts as "PCI space and the BIOS code and data
> regions" but:
> 
> $ grep STRICT_DEVMEM -A 15 arch/x86/Kconfig.debug
> config STRICT_DEVMEM
>         bool "Filter access to /dev/mem"
>         ---help---
> 

Yes, having this option turned on an access to LAPIC/IO_APIC
space will be forbidden.

	-- Cyrill

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbYEUFqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbYEUFqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 01:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYEUFqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 01:46:05 -0400
Received: from zm1.veloxia.com ([213.149.227.2]:54520 "HELO zm1.veloxia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753815AbYEUFqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 01:46:05 -0400
Message-ID: <4833B717.5030005@hvsistemas.es>
Date: Wed, 21 May 2008 07:45:59 +0200
From: Javier Herrero <jherrero@hvsistemas.es>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Bryan Wu <cooloney@kernel.org>
Subject: Re: b4aa54d951d38d7a989d6b6385494ef5ea7371d7 breaks some serial configurations
References: <20080520073556.GA1090@flint.arm.linux.org.uk> <483286AF.2090302@hvsistemas.es> <20080520083217.GA10172@flint.arm.linux.org.uk> <4832AD84.6090300@hvsistemas.es> <20080520231323.GA10750@flint.arm.linux.org.uk>
In-Reply-To: <20080520231323.GA10750@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps then, at least for now, in order to quickly restore the 
functionality of the driver with other platforms and to continue having 
the 8250 support in the blackfin, would be to apply this patch, that is 
a bit ugly but at least only affects to blackfin platforms using 
8250-class uarts :)

Regards,

Javier

Russell King escribió:
> On Tue, May 20, 2008 at 12:52:52PM +0200, Javier Herrero wrote:
>> I see... would be OK to move the asm/serial.h include to its original 
>> position and to modify the asm-blackfin/serial.h in this way to avoid 
>> duplicate definition warnings, or would it be too ugly?:
>
> Can blackfin systems accept PCMCIA cards?  Or PCI cards?  In which case
> you probably don't want to implement this support like this.
>
> A better solution may be to add some UPF_ flags to indicate the interrupt
> polarity on a per-port basis.  Not sure I'm particularly thrilled by that
> idea though, but other solutions I can think of inspire me even less.
>

-- 
------------------------------------------------------------------------
Javier Herrero                            EMAIL: jherrero@hvsistemas.com
HV Sistemas S.L.                          PHONE:         +34 949 336 806
Los Charcones, 17A                        FAX:           +34 949 336 792
19170 El Casar - Guadalajara - Spain      WEB: http://www.hvsistemas.com 


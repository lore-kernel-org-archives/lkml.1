Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZAUXey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZAUXey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZAUXen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:34:43 -0500
Received: from h155.mvista.com ([63.81.120.155]:5642 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753459AbZAUXem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:34:42 -0500
Message-ID: <4977B10B.5050904@ru.mvista.com>
Date: Thu, 22 Jan 2009 02:34:35 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Hugh Dickins <hugh@veritas.com>,
       Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>	<18807.33113.550070.329912@harpo.it.uu.se>	<20090121214746.2b15d1de@lxorguk.ukuu.org.uk>	<4977A6E5.6080506@ru.mvista.com> <20090121225808.1f5ffac1@lxorguk.ukuu.org.uk>
In-Reply-To: <20090121225808.1f5ffac1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>>>>  > I've a Dell Precision 670 here (four-year-old EM64T Xeon with ata_piix)
>>>>  > which doesn't like your commit 871af1210f13966ab911ed2166e4ab2ce775b99d
>>>>  > libata: Add 32bit PIO support.  Full dmesg (and .config) attached, but
>>>>  > here's an extract showing the start of the error messages on ata2:
>>>>     
>>>>         
>>> Cool - so we need two different 32bit PIO methods - at least according to
>>> the docs for the AMD we should use entirely 32bit I/O there. Fun fun
>>>   
>>>       
>>    Could you refer me to the exact AMD doc that requires that?
>>     
>
> AMD762 page 82, under DevB:1x40 bit 14 and bit 12
>   

   What exactly AMD-762 document has this? I'm not seeing it in either 
stasheet ot software/BIOS design guide. Besides, AMD-762 is a north 
bridge and doesn't include IDE.

> "Note: only 32-bit writes to the data port are allowed when this bit is
> set."
>   
  
   Now tell me who forces you to set that bit (I assume it's the write 
buffer enable) for the ATAPI devices?

WBR, Sergei



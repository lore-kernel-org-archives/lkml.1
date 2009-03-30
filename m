Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbZC3Ukw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbZC3Ukw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbZC3Ukn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:40:43 -0400
Received: from rtr.ca ([76.10.145.34]:33070 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758561AbZC3Ukm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:40:42 -0400
Message-ID: <49D12E47.5050803@rtr.ca>
Date: Mon, 30 Mar 2009 16:40:39 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jeff Garzik <jeff@garzik.org>, Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain> <49D0FD4C.1010007@redhat.com> <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain> <49D11BDD.70702@redhat.com> <49D1206E.7090809@garzik.org> <49D129B4.1060503@msgid.tls.msk.ru> <49D12B10.20805@rtr.ca> <49D12D26.7080203@garzik.org>
In-Reply-To: <49D12D26.7080203@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Mark Lord wrote:
>> Michael Tokarev wrote:
>>>
>>> But are there drives out there that actually supports FUA?
>> ..
>>
>> Most (or all?) current model Hitachi Deskstar drives have it.
> 
> Depends on your source of information:  if you judge from probe 
> messages, libata_fua==0 will imply !FUA-support.
..

As your other post points out, lots of drives already support FUA,
but libata deliberately disables it by default (due to the performance
impact, similar to mounting a f/s with -osync).


For the curious, you can use this command to see if your hardware has FUA:

   hdparm -I /dev/sd? | grep FUA

It will show lines like this for the drives that support it:
 
  *    WRITE_{DMA|MULTIPLE}_FUA_EXT

Cheers

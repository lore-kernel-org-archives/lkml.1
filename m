Return-Path: <linux-kernel-owner+w=401wt.eu-S1764285AbXILUmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764285AbXILUmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbXILUmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:42:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:46193 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbXILUmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YfPG1xmqLkLHRM/PJS234YBTdIutsK8DHXWajDAtr0WaYtdeQf5T3Ac4m80VUmo6CxNWZvz8zZ5kMz/cSsvqhTXm3agFuhvPTueI3gsuLpCO3C1TErnvXT8pENYR1v4Kdk4wDOg6gTRzMy+Z3r2V0ewYqKMc3Yc8JjIwY/rE588=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: patrizio.bassi@gmail.com
Subject: Re: libata not working for sis5533
Date: Wed, 12 Sep 2007 22:44:54 +0200
User-Agent: KMail/1.9.6
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-acpi@vger.kernel.org
References: <46D132C5.5000803@gmail.com> <Pine.LNX.4.64.0709122018400.22467@fbirervta.pbzchgretzou.qr> <46E834A2.2020205@gmail.com>
In-Reply-To: <46E834A2.2020205@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709122244.54702.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 12 September 2007, Patrizio Bassi wrote:
> Jan Engelhardt ha scritto:
> > On Sep 11 2007 15:46, Andrew Morton wrote:
> >   
> >> Patrizio Bassi <patrizio.bassi@gmail.com> wrote:
> >>     
> >>> Jan Engelhardt ha scritto:
> >>>       
> >>>> On Sep 8 2007 11:38, Patrizio Bassi wrote:
> >>>>         
> >>>>> Jan Engelhardt wrote:
> >>>>>    
> >>>>>           
> >>>>>> I shall give this a spin too, since I happen to have sis5513. Just
> >>>>>> booted this fresh ata-enabled system (a matter of mkinitrd). It has not
> >>>>>> exploded yet.
> >>>>>>      
> >>>>>>             
> >>>>> don't you have the "irq 14" issue?
> >>>>>    
> >>>>>           
> >>>> No, does not seem so.
> >>>>         
> >>> For Alan, libata devs...hope can help debug...
> >>> this is http://www.patriziobassi.it/downloads/libata_issue.jpg
> >>>       
> >> Looks more like a platform irq routing issue than an ata issue.
> >>
> >> Perhaps an x86 or an acpi person can help out with this.
> >>     
> >
> > Patrizio, have you tried with the old IDE? (And without suspend at that...)
> >
> >
> >   
> 
> yes yes old IDE works ok, but the suspend functionality is broken....
> so, as i compile scsi subsystem for usb-storage i wanted to move to the
> new libata, but i found this issue...

w.r.t. to suspend problem (http://bugzilla.kernel.org/show_bug.cgi?id=7077):
please try latest -mm kernel, it contains many fixes for sis5513 host driver.

Thanks,
Bart

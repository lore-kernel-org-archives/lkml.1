Return-Path: <linux-kernel-owner+w=401wt.eu-S1751403AbZG3FhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbZG3FhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 01:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZG3FhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 01:37:00 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:54823 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZG3Fg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 01:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TR4h7P3YA9OOa5x66eWCkT7OWwweK7PzATHMUYv4SMaY/3AN/TfW3n+CSJpkJKpGMi
         OGS1kkuElL3qLK/PsFVu+ZKHDFmA/KMyyp+2aX/iTGKnnHFG/dHRMDIUU1w+1sKyNYl2
         bpCSkH4lXKF1bDLUKkz/vEzIoB3lYWaUkQDFM=
MIME-Version: 1.0
In-Reply-To: <7a7c22420907280357p71c495f8x9923227eef000391@mail.gmail.com>
References: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
	 <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>
	 <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com>
	 <1247670563.4236.16.camel@mulgrave.site> <4A645FCE.5030506@suse.de>
	 <7a7c22420907220626t11f510b7q835add0d5b7ecc94@mail.gmail.com>
	 <7a7c22420907280357p71c495f8x9923227eef000391@mail.gmail.com>
Date: Thu, 30 Jul 2009 11:06:59 +0530
Message-ID: <7a7c22420907292236x1b528153pe22e53473c22626a@mail.gmail.com>
Subject: Re: SCSI command (SP-OUT) failing on SLES 9 32-bit
From: rohan a <info1686@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
      I checked var/log/messages
These are the errors reported:
=======================================================
kernel: mptbase: ioc0: IOCStatus(0x0003): Invalid SGL
kernel: mptbase: ioc0: LogInfo(0x11070000): F/W: DMA Error
kernel: mptbase: ioc0: LogInfo(0x11070000): F/W: DMA Error
kernel: mptbase: ioc0: IOCStatus(0x004b): SCSI IOC Terminated
kernel: st0: Error with sense data: Current st0: sense key Unit Attention
kernel: Additional sense: Scsi bus reset occurred
=========================================================

Thanks


On 7/28/09, rohan a <info1686@gmail.com> wrote:
> Hi all/Hannes,
>
> Any help/suggestions?
>
>
> On Wed, Jul 22, 2009 at 6:56 PM, rohan a<info1686@gmail.com> wrote:
> > Hi,
> >       Thanks for a reply.
> > I have 2 SLES 9 32-bit machines, on one I am using an FC HBA card and
> > another a SCSI HBA card to connect LTO-4 standalone drives and drive
> > based encryption is not working in both cases.
> >
> > Thanks
> >
> > On Mon, Jul 20, 2009 at 5:45 PM, Hannes Reinecke<hare@suse.de> wrote:
> >> James Bottomley wrote:
> >>> On Wed, 2009-07-15 at 20:33 +0530, rohan a wrote:
> >>>> Hi guys,
> >>>>
> >>>> Any suggestions...please help
> >>>
> >>> I know of no kernel bug that could be causing this.  The SLES9 kernel is
> >>> just too old though for me to remember clearly.  I'd suggest you file a
> >>> support incident with SUSE ... they'll debug and fix this on the older
> >>> kernels; we really only deal with the new kernel and one or two back
> >>> revisions here on linux-scsi.
> >>>
> >> You did that on purpose.
> >> The 'they' is actually me :-(
> >>
> >> Actually, there already _is_ a bug, so no need to open another one.
> >> Which HBA are you using?
> >>
> >> Cheers,
> >>
> >> Hannes
> >> --
> >> Dr. Hannes Reinecke                   zSeries & Storage
> >> hare@suse.de                          +49 911 74053 688
> >> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
> >> GF: Markus Rex, HRB 16746 (AG Nürnberg)
> >>
> >
>

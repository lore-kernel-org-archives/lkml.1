Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbYG0UsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbYG0UsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 16:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbYG0UsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 16:48:15 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:44582
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757740AbYG0UsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 16:48:15 -0400
X-Trace: 116046322/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEFABt8jEjDlSwG/2dsb2JhbACBW4k8oVw
X-IronPort-AV: E=Sophos;i="4.31,260,1215385200"; 
   d="scan'208";a="116046322"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Simen Timian Thoresen <simentt@dolphinics.no>
Subject: Re: Misidentification and failing revalidations of ide dvd-roms with libata
Date: Sun, 27 Jul 2008 21:47:42 +0100
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <48838593.8020007@dolphinics.no> <200807202103.51889.alistair@devzero.co.uk> <488CCD81.7010002@dolphinics.no>
In-Reply-To: <488CCD81.7010002@dolphinics.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807272147.42264.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 July 2008 20:33:21 Simen Timian Thoresen wrote:
[snip]
> I've spent a few hours more looking into this, and I'm not really
> getting much clearer;
>
> I've run either and both of the two DVDroms on an external power-supply
> (drive-power from a jumped, believed good ATX-PSU), and the the symptoms
> remain; inconsistent capabilities reported at boot, and when I start
> ripping CDs, one of them will fail as above.
>
> As I still have the impression that this started when I switched distros
> (ie went from CentOS4 2.6.9 pre-libata-kernel to the current Ubuntu 8.04
> 2.6.24-kernel), I've now started playing around with the libata module
> parameters.

If it's not power then I'm still with Alan re the cables. Maybe you have very 
long cables?

I used Alan's nForce4 pata driver for a year or so and didn't have any 
problems. OTOH maybe at this stage it's worth checking whether amd74xx (old 
IDE) breaks in similar ways?

Also, I assume you've memtest86'ed the machine?

-- 
Cheers,
Alistair.

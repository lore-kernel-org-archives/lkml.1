Return-Path: <linux-kernel-owner+w=401wt.eu-S965701AbXCLMHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965701AbXCLMHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 08:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965739AbXCLMHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 08:07:32 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.8]:1357 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965701AbXCLMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 08:07:31 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: 2.6.20*: PATA DMA timeout, hangs (2)
Date: Mon, 12 Mar 2007 12:07:18 +0000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070312085447.GA10955@janus> <20070312112414.GA12265@janus>
In-Reply-To: <20070312112414.GA12265@janus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121207.19042.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 11:24, Frank van Maarseveen wrote:
> On Mon, Mar 12, 2007 at 09:54:47AM +0100, Frank van Maarseveen wrote:
> > 2.6.19 is ok, 2.6.20.[12] hangs from the moment DMA is turned on (hdparm
> > -d 1 /dev/hda):
> >
> > 	hda: dma_timer_expiry: dma status == 0x20
> > 	hda: DMA timeout retry
> > 	hda: timeout waiting for DMA
> > 	hda: status error: status=0x58 {
> > 	DriveReady
> > 	SeekComplete
> > 	DataRequest
> > 	}
[snip]
> This system has SATA but there's only one PATA disk

Not a solution, unfortunately, but try disabling CONFIG_IDE and using Alan's 
new PATA drivers. For your Intel systems, this should mean you need only:

CONFIG_ATA_PIIX

For both SATA and PATA support. You'll need the appropriate SCSI modules built 
in (if you say =y), i.e. SCSI disk and SCSI CDROM should be built in.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.

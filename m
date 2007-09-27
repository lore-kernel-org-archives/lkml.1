Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbXI0QFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbXI0QFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXI0QFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:05:05 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58040 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbXI0QFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:05:03 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 27 Sep 2007 12:03:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: correct kernel parameter in documentation.
In-Reply-To: <20070927155013.GA20219@redhat.com>
Message-ID: <Pine.LNX.4.64.0709271202210.13117@localhost.localdomain>
References: <20070927155013.GA20219@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007, Dave Jones wrote:

> 'noacpi' isn't a standalone parameter, give it its prefix.
>
> Signed-off-by: Dave Jones <davej@redhat.com>
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4d175c7..a87bc58 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -863,6 +863,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
>  			Format: addr:<io>,irq:<irq>
>
> +	libata.noacpi	[LIBATA] Disables use of ACPI in libata suspend/resume
> +			when set.
> +			Format: <int>
> +

if you're going to add that libata-related parm to the kernel parms
file, wouldn't it make sense for consistency to add the other
available boot-time parms from libata-core.c as well?  it seems
counter-productive to document only a subset of them from the same
source file.

rday

p.s.  as i think i've mentioned before, i'd prefer to see that entire
kernel-parameters.txt file reorganized, where the basic boot time
parms are at the top, followed by module specific parameters *after*
that, in alphabetical order by module name.  i think that would make
far more sense.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================

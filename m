Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZHFOvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZHFOvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZHFOvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:51:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51075 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZHFOva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:51:30 -0400
Date: Thu, 6 Aug 2009 15:51:25 +0100
From: Matthew Garrett <mjg@redhat.com>
To: =?iso-8859-1?Q?H=E5kon_L=F8vdal?= <hlovdal@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       shaohua.li@intel.com, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/3] libata: Bind the Linux device tree to the ACPI
	device tree
Message-ID: <20090806145125.GB3181@srcf.ucam.org>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com> <1247518987-10818-2-git-send-email-mjg@redhat.com> <a01a16b50908052354h28522bafja255c4fcac9a2ea8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a01a16b50908052354h28522bafja255c4fcac9a2ea8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 08:54:31AM +0200, Håkon Løvdal wrote:
> Maybe I am missing something, but wouldn't it be more natural to write this as
> 
>         if (sata_pmp_attached(ap))
>                 adr = SATA_ADR(ap->port_no, dev->link->pmp);
>         else
>                 adr = SATA_ADR(ap->port_no, NO_PORT_MULT);

Heh, yes. That would also work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

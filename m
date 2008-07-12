Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYGLHxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYGLHxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYGLHww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:52:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:17831 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYGLHwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=enj2scHrNEOUQpI8Z1eHVKhFNizB4kFjTCJCRC5Vu5/t0/byUEbsAmm+HRiavIsTK0
         9AoqD3vqagbzEl5u/sSsAKipw6Z/r9ZZNG/snsVH5Yer1opXFgxZNk5irdm9XIryK/Ot
         i3oUafauAkLeExgddW7+Th6Sc3HAMKnUU5p0c=
Message-ID: <e2e108260807120052j5264ba21u118dda546128dd35@mail.gmail.com>
Date: Sat, 12 Jul 2008 09:52:47 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] [ANNOUNCE]: Generic SCSI Target Mid-level For Linux (followup)
Cc: "Vladislav Bolkhovitin" <vst@vlnb.net>, "Andrew Morton" <akpm@osdl.org>,
       "Rafiu Fakunle" <rafiu@openfiler.com>, linux-scsi@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>, "David Miller" <davem@davemloft.net>,
       "Mike Mazarick" <mazarick@bellsouth.net>,
       "Leonid Grossman" <leonid.grossman@neterion.com>,
       linux-kernel@vger.kernel.org, "Pete Wyckoff" <pw@osc.edu>,
       "Ross S. W. Walker" <rwalker@medallion.com>,
       scst-devel <scst-devel@lists.sourceforge.net>,
       "Ted Ts'o" <tytso@thunk.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Jerome Martin" <tramjoe.merin@gmail.com>,
       "Christoph Hellwig" <hch@lst.de>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
In-Reply-To: <1215833281.13668.94.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4873BCA5.10103@vlnb.net>
	 <1215551354.3977.6.camel@haakon2.linux-iscsi.org>
	 <48749EB2.1070902@vlnb.net>
	 <1215632043.9339.89.camel@haakon2.linux-iscsi.org>
	 <48765433.70604@vlnb.net>
	 <1215725167.31245.104.camel@haakon2.linux-iscsi.org>
	 <4877A948.6090507@vlnb.net>
	 <1215833281.13668.94.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 5:28 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Using MC/S with a modern iSCSI implementation to take advantage of lots
> of cores and hardware threads is something that allows one to multiplex
> across multiple vendor's NIC ports, with the least possible overhead, in
> the OS INDEPENDENT manner.

Why do you emphasize MC/S so much ? Any datacenter operator that has
the choice between MC/S and using a faster network technology will
choose the last IMHO. It's much more convenient to use e.g. 10 GbE
instead of multiple 1 GbE connections.

Bart.

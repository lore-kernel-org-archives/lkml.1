Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYAOUlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYAOUlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbYAOUlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:41:42 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:26499 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbYAOUll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:41:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MiUBEE5+IAmv1yH2U7sWcEI69wAKrBI1CqzeyHrPhz/r7xs3efHKhA+1aqZBp3EqXLPtgw4d3UzVNTJsLw0d0r9333xWnfrgRuZmWrlTkxouDoRFXWv2lx8r14iTczLj6zFNFtd8zjIQgkjOaSrjC/pvhtYkLExvWtdsAjdpHtM=
Message-ID: <8b67d60801151241p31ade7ald4421dc0f34d5212@mail.gmail.com>
Date: Tue, 15 Jan 2008 20:41:39 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Adrian McMenamin" <adrian@newgolddream.dyndns.info>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom CDROM drive on SEGA Dreamcast
In-Reply-To: <20080115002958.GA27597@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200007549.6349.16.camel@localhost.localdomain>
	 <1200088609.6213.3.camel@localhost.localdomain>
	 <20080112053630.0ccb290e.akpm@linux-foundation.org>
	 <1200351607.6196.4.camel@localhost.localdomain>
	 <1200352635.6196.8.camel@localhost.localdomain>
	 <20080115002958.GA27597@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/2008, Paul Mundt <lethal@linux-sh.org> wrote:
> On Mon, Jan 14, 2008 at 11:17:15PM +0000, Adrian McMenamin wrote:

>
> > +static bool gdrom_data_request(void)
> > +{
> > +     return (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) == 8;
> > +}
> > +
> Andrew first pointed this out, and this is still broken.
>

Eh, no, he didn't. What is wrong with it?

He compalined about excessively long busy waiting and then not
checking if the busy wait failed. Both those have been fixed.

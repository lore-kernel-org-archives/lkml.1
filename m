Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYAPB6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYAPB6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbYAPB6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:58:23 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:62964 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756599AbYAPB6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:58:22 -0500
Date: Wed, 16 Jan 2008 10:57:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Jens Axboe <jens.axboe@oracle.com>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom CDROM drive on SEGA Dreamcast
Message-ID: <20080116015737.GA8697@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1200007549.6349.16.camel@localhost.localdomain> <1200088609.6213.3.camel@localhost.localdomain> <20080112053630.0ccb290e.akpm@linux-foundation.org> <1200351607.6196.4.camel@localhost.localdomain> <1200352635.6196.8.camel@localhost.localdomain> <20080115002958.GA27597@linux-sh.org> <8b67d60801151241p31ade7ald4421dc0f34d5212@mail.gmail.com> <1200007549.6349.16.camel@localhost.localdomain> <1200088609.6213.3.camel@localhost.localdomain> <20080112053630.0ccb290e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60801151241p31ade7ald4421dc0f34d5212@mail.gmail.com> <20080112053630.0ccb290e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 05:36:30AM -0800, Andrew Morton wrote:
> On Fri, 11 Jan 2008 21:56:49 +0000 Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:
> > +/* keep the function looking like the universal CD Rom specification - returning int*/
> > +static int gdrom_packetcommand(struct cdrom_device_info *cd_info, struct packet_command *command)
> > +{
> > +	gdrom_spicommand(&command->cmd, command->buflen);
> > +	return 0;
> > +}
> 
> Please pass the diff through scripts/checkpatch.pl.  Some things, like the
> above, you may choose to fix.  Some you definitely will.

On Tue, Jan 15, 2008 at 08:41:39PM +0000, Adrian McMenamin wrote:
> On 15/01/2008, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Mon, Jan 14, 2008 at 11:17:15PM +0000, Adrian McMenamin wrote:
> 
> >
> > > +static bool gdrom_data_request(void)
> > > +{
> > > +     return (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) == 8;
> > > +}
> > > +
> > Andrew first pointed this out, and this is still broken.
> >
> 
> Eh, no, he didn't. What is wrong with it?
> 
Quoted above for your convenience.

> He compalined about excessively long busy waiting and then not
> checking if the busy wait failed. Both those have been fixed.

This was also covered in the checkpatch output that you conveniently
trimmed in your reply. If you can't see the problem, either your version
of checkpatch or your editor are broken. Huge amounts of your patch
continue to be whitespace damaged, and while you claim to have fixed
that, checkpatch continually whines about the same thing in each
iteration of your patch. Please just fix it up instead of arguing about
it, thanks.

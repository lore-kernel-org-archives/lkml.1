Return-Path: <linux-kernel-owner+w=401wt.eu-S1765619AbYBZWYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765619AbYBZWYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbYBZWX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:28276 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbYBZWX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rChmTxw3mmn3ZuEJLIfvhM9jHrmf3VJkhFg5TD5LHKMKv9i596f+QIwYZU1slDkoS3815Trv002HAPx0Lv2XtQFw3L2OfIaKIZ+Br4xeOfZtS57Drfx87uTqXTpsXmS2wNJCJO2ItbqlXR+0/rEGEyV7C8C9gm50xfKUt3A4weg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
Date: Tue, 26 Feb 2008 21:01:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Andreas Schwab <schwab@suse.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       j-nomura@ce.jp.nec.com
References: <20080218.135827.74754725.k-ueda@ct.jp.nec.com> <jebq63epnm.fsf@sykes.suse.de> <20080226173855.GA5497@gollum.tnic>
In-Reply-To: <20080226173855.GA5497@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262101.53706.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008, Borislav Petkov wrote:
> On Tue, Feb 26, 2008 at 03:52:13PM +0100, Andreas Schwab wrote:
> > Borislav Petkov <petkovbb@googlemail.com> writes:
> > 
> > > On Mon, Feb 25, 2008 at 11:08:55PM +0100, Andreas Schwab wrote:
> > >> Borislav Petkov <petkovbb@googlemail.com> writes:
> > >> 
> > >> > On Mon, Feb 25, 2008 at 08:38:22PM +0100, Andreas Schwab wrote:
> > >> >> "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com> writes:
> > >> >> 
> > >> >> > I'm looking at this problem, but currently no idea why the conversion
> > >> >> > to blk_end_request causes it.
> > >> >> 
> > >> >> cdrom_newpc_intr apparently never sets rq->sense_len.
> > >> >> 
> > >> >
> > >> > actually it does, see the code chunk around line 1188 in 2.6.25-rc2, for
> > >> > example.
> > >> 
> > >> Yes, it does, but it always adds zero.
> > >
> > > yep, true. Does that fix your dvd burning problem?
> > 
> > Yes, sure.
> > 
> > Andreas.
> 
> Bart,
> 
> please apply the enclosed patch since it fixes dvd burning with growisofs on
> Pioneer drives as reported by Andreas.
> 
> Thanks.
> 
> ---
> From: Andreas Schwab <schwab@suse.de>
> 
> Move counting of sense bytes into the transfer loop.
> 
> Signed-off-by: Andreas Schwab <schwab@suse.de>
> Acked-by: Borislav Petkov <petkovbb@gmail.com>

applied, thanks!

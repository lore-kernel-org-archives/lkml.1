Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbYAOHS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbYAOHS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 02:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYAOHSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 02:18:18 -0500
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:25550 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752455AbYAOHSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 02:18:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=4AI8FUM8XpcsLxJtkTRyxms3NbRRdaguq7Gz1JTDy7IzbN4Xg8MeWd3Nwsq5QgbmCpLq+MT7GjH/eKce3dHBqnXmKBxZJ19t+7M+22JqXFxPL60sILTe7MzSwSKdTVdj0OBCnjyDe13/iF0HthdbrWBYbhpwyZcgagUTaiU8pU8=  ;
X-YMail-OSG: Atn69fEVM1k2CtHmC7kbTB1_791VJv3OEFTVjiPNWZJZ3YHJxdxGrazvWu7fmsv37pEM_b.icQ--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 15 Jan 2008 08:14:34 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 8/12] ide-floppy: merge idefloppy_{input,output}_buffers
Message-ID: <20080115071434.GB32009@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-8-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-9-git-send-email-bbpetkov@yahoo.de> <200801142238.35893.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801142238.35893.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 10:38:35PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 13 January 2008, Borislav Petkov wrote:
> > We merge idefloppy_{input,output}_buffers() into idefloppy_io_buffers() by
> > introducing a 4th arg. called direction. According to its value
> > we atapi_input_bytes() or atapi_output_bytes(). Also, this simplifies the
> > interrupt handler logic a bit. Finally, rename idefloppy_io_buffers() to
> > ide_floppy_io_buffers().
> > 
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> 
> This change depends on "ide-floppy: use an xfer_func_t and io_buf_t typedefs
> in order to unify rw" which was not in the "v2.5" series.

Yep, this is correct. Probably i should've mentioned that in the preamble. It
is rather confusing, imho, when sending only a subset of the patches. Rather,
I should've sent the whole series after tagging the ones already applied so
that you have an idea about their ordering. Will note that for the next time.

> I took the patch #16/21 from the previous series and applied it manually
> fixing rejects, please verify that I didn't brake something in the process.

Will do the whole driver testing in the weekend. :)

-- 
Regards/Gruﬂ,
    Boris.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYA2V41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYA2V41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYA2V4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:56:19 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:17841 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794AbYA2V4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:56:17 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <479F9FA4.8020504@zytor.com>
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
	 <479E5D22.1070109@goop.org>
	 <1201599251.5301.26.camel@localhost.localdomain>
	 <479F6845.1070902@goop.org> <479F6AD2.8050908@zytor.com>
	 <479F70E9.40905@goop.org>  <479F71B6.2010305@zytor.com>
	 <1201639112.9516.23.camel@cthulhu.hellion.org.uk>
	 <479F9FA4.8020504@zytor.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 21:55:58 +0000
Message-Id: <1201643758.9516.25.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 13:50 -0800, H. Peter Anvin wrote:
> Ian Campbell wrote:
> > 
> > I finessed the length issue slightly since it happens that the word
> > before the payload is the payload's length. I'm mulling a variety of
> > options:
> >       * declare it compression scheme dependant. At least for gzip
> it
> >         knows when it has reached the end.
> >       * codify the length followed by data thing we happen to have
> now
> >       * add a length field to the header, using another 4 bytes (is
> >         there any pressure on the size of the header?).
> > 
> > I'd probably go with the later unless we are pressed for space in
> the
> > header.
> 
> I would agree with that.  In fact, while we're adding fields to the 
> header, I would like to add a field that would be the CRC32 (or other 
> simple integrity check) over the whole image.

As in over the whole compressed payload part? I'll add that while I'm
there.

Ian.
-- 
Ian Campbell

"Jesus may love you, but I think you're garbage wrapped in skin."
		-- Michael O'Donohugh


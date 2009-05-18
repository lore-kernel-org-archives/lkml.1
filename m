Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZERO0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZERO0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZEROZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:25:53 -0400
Received: from mail-px0-f191.google.com ([209.85.216.191]:44877 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZEROZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:25:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=dIONCyA2EqPphBbdD9iVF7Y9iMbXkcDGHSRboQk0lwnyr+WZQi/83RZngYW3zUExWR
         U3WIzfOuDyYwXpKMUnn8LfI9uFc24iLhVqCZ3O4cC0Ohd6Ob1UfUAa2QZbHImDuMWRHK
         CjczyH71gVrqt/NB99sCOA/BzdTURzSH1eIIg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Richard Atterer <richard@2009.atterer.net>
Subject: Re: s2disk hangs with kernel >=2.6.29, SATA, Gigabyte EG45M-DS2H (bisected)
Date: Mon, 18 May 2009 16:29:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>, linux-ide@vger.kernel.org
References: <20090516225153.GA7883@arbonne.lan> <200905180117.28413.bzolnier@gmail.com> <20090518141646.GA6460@arbonne.lan>
In-Reply-To: <20090518141646.GA6460@arbonne.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905181629.33234.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009 16:16:46 Richard Atterer wrote:
> On Mon, May 18, 2009 at 01:17:27AM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 17 May 2009 00:51:53 Richard Atterer wrote:
> > > The patch that causes the hang is 295f00042aaf6b553b5f37348f89bab463d4a469:
> > > ide: don't execute the next queued command from the hard-IRQ context (v2)
> > 
> > Hmm, this should have been fixed by:
> > 
> > commit 2ea5521022ac8f4f528dcbae02668e02a3501a5a
> > Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Date:   Wed Jan 14 19:19:04 2009 +0100
> > 
> >     ide: fix suspend regression
> 
> I just tried that revision (with a small patch to get pcf50633-core to 
> compile) and hibernating does not work. :-/

Ok, thanks for testing it, also just to make sure:

Does the one commit before 295f00042aaf6b553b5f37348f89bab463d4a469
(namely ebdab07dad3d3a008e519b0a028e1e1ad5ecaef0) work fine?

Thanks.
Bart

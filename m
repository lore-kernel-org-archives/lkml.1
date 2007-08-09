Return-Path: <linux-kernel-owner+w=401wt.eu-S940380AbXHIPNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940380AbXHIPNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbXHIPNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:13:37 -0400
Received: from web25012.mail.ukl.yahoo.com ([217.146.183.115]:23289 "HELO
	web25012.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762075AbXHIPNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:13:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3hIHEWKTOUYmXrH3hPVN/AwESErJZ06LuyawDzlGvXEQSEx86xY1Q3KdoqhNmouuY9cW5/C2dADHGo0Ki9Q2i+u66BUcR2+KWUSSX3JtjAjjh/WlADjR93RKl48Ce/Ns8aAtk0LOzSKnc8R4j+was867yTptaXJD/WxlUxvJeDo=;
X-YMail-OSG: O2S5.yAVM1mcPZW_eSRpZyFJVCPEjDF2FZ1zoxWES2Mrj7.CeVUljR4M56hKRYrGROIQO5EX5fdXdAHCDC481xSluO0xqO..NAJLIIH6_mS3hRQy2sQtuudJnhU-
Date: Thu, 9 Aug 2007 16:06:54 +0100 (BST)
From: Steven Newbury <s_j_newbury@yahoo.co.uk>
Subject: Re: [PATCH] pxa2xx PCMCIA timing issue on iPAQ H5550
To: Milan Plzik <milan.plzik@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-pcmcia@lists.infradead.org
In-Reply-To: <1186172532.32154.30.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <817976.91299.qm@web25012.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Milan Plzik <milan.plzik@gmail.com> wrote:

>   Good day,
> 
>   recently I've been trying to get working PCMCIA interface on H5000
> ipaq series, using dual PCMCIA sleeve. So far things work correctly, but
> I had to do one modification to drivers/pcmcia/pxa2xx_base.c to get the
> interface working with orinoco gold PCMCIA card (wired pcnet_cs ethernet
> card worked even without this modification). Patch attached.
> 
>   The issue has something to do with assert time on PCMCIA bus, but I'm
> not really sure what -- I found the working value just by trial&error
> approach. I'm not sure how is the assert value in pxa2xx_mcxx_asst
> calculated (I know, simple formula, but the reason why is it calculated
> that way is not obvious for me), neither that my modification is
> correct. It just works with iPAQ. 
> 
I posted a patch to linux-arm-kernel which reworked the timing code.  The
existing is/was IMHO wrong and this showed up for me with frequency scaling
where the code would not keep the PCMCIA timings constant with changes to the
core frequency.  Here it is:
http://marc.info/?l=linux-arm-kernel&m=116861295404294&w=2


Steve


      ___________________________________________________________
For email that puts you in control, choose Yahoo! Mail.
http://uk.docs.yahoo.com/mail/addressguard2.html

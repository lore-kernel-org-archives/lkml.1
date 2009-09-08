Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZIHLcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZIHLcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZIHLcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:32:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60384 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbZIHLcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:32:51 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Date: Tue, 8 Sep 2009 13:32:45 +0200
User-Agent: KMail/1.9.9
Cc: Nikos Chantziaras <realnc@arcor.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <20090906205952.GA6516@elte.hu> <20090908013800.296a5fb5@infradead.org> <4AA62E4E.4040700@arcor.de>
In-Reply-To: <4AA62E4E.4040700@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909081332.46129.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 8. September 2009, Nikos Chantziaras wrote:
> On 09/08/2009 11:38 AM, Arjan van de Ven wrote:
> > On Tue, 08 Sep 2009 10:19:06 +0300
> >
> > Nikos Chantziaras<realnc@arcor.de>  wrote:
> >> latencytop has this to say:
> >>
> >>     http://foss.math.aegean.gr/~realnc/pics/latop1.png
> >>
> >> Though I don't really understand what this tool is trying to tell me,
> >> I hope someone does.
> >
> > despite the untranslated content, it is clear that you have scheduler
> > delays (either due to scheduler bugs or cpu contention) of upto 68
> > msecs... Second in line is your binary AMD graphics driver that is
> > chewing up 14% of your total latency...
>
> I've now used a correctly installed and up-to-date version of latencytop
> and repeated the test.  Also, I got rid of AMD's binary blob and used
> kernel DRM drivers for my graphics card to throw fglrx out of the
> equation (which btw didn't help; the exact same problems occur).
>
> Here the result:
>
>      http://foss.math.aegean.gr/~realnc/pics/latop2.png
>
> Again: this is on an Intel Core 2 Duo CPU.

Just an idea: Maybe some system management code hits you?

jbe

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |

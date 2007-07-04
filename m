Return-Path: <linux-kernel-owner+w=401wt.eu-S1760633AbXGDI5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633AbXGDI5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbXGDI5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:57:03 -0400
Received: from www19.your-server.de ([213.133.104.19]:36616 "EHLO
	www19.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbXGDI5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:57:01 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
Date: Wed, 4 Jul 2007 10:56:53 +0200
User-Agent: KMail/1.9.7
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <468AA364.2010000@nortel.com> <468AB976.2010806@redhat.com>
In-Reply-To: <468AB976.2010806@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041056.53992.u.luckas@road.de>
X-Authenticated-Sender: webmaster@road.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3. July 2007, Chuck Ebbert wrote:
> On 07/03/2007 03:28 PM, Chris Friesen wrote:
> > Arne Georg Gleditsch wrote:
> >> An interesting exercise might be to
> >> code up a small program to call adjtimex with timex.status |= STA_INS,
> >> to see if this can trigger the problem.
> >
> > Setting the date to just before midnight June 30 UTC and then running
> > the following as root triggered the crash on a modified 2.6.10.  Anyone
> > see anything wrong with the code below, or is this a valid indication of
> > a bug in the leap second code?
>
> Fixed:
> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=comm
>itdiff;h=746976a301ac9c9aa10d7d42454f8d6cdad8ff2b
>
Hi Chris,
does that qualify for inclusion into 2.6.21.6?

regards,
Uli

-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit

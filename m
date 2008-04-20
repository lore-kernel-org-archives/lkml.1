Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbYDTOyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbYDTOyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYDTOye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:54:34 -0400
Received: from web36705.mail.mud.yahoo.com ([209.191.85.39]:34595 "HELO
	web36705.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753507AbYDTOyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:54:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=g+wKU+7LyMovBo5ZuUIamKjgo6hJNI/hHJgL9evMxZZW/uf7opsDp7XZwqjS1cwiclf4/ch44zq0ymxF50LmqAOgGInWJXAVz8DUd0eMyKT8WMmE1x71DAXbF5stiWugpQaEj0k1xp5CGtzVZT1nAjDM1jP5QMfaLK1apfpg9hU=;
X-YMail-OSG: psndrpkVM1ku29YCziEWmgWmiF_gcCPSj93StpWTFnwsaVx15vqAUVOAQzXo7rr1A0zgk4Tk8Cf6CuTUVp8WS4pkoTowmzapWXcAl2bZkpga0EBZklNt0a2IDQ--
Date: Sun, 20 Apr 2008 07:54:32 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [RFC] MMC multiwrite capability removal
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: David Brownell <david-b@pacbell.net>, Andrew Victor <linux@maxim.org.za>,
       Pavel Pisa <ppisa@pikron.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       Anderson Briglia <briglia.anderson@gmail.com>,
       "Syed Mohammed, Khasim" <x0khasim@ti.com>,
       Russell King <rmk@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080420103019.7c31cb9f@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <671558.27051.qm@web36705.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> On Sat, 19 Apr 2008 19:34:12 -0700 (PDT)
> Alex Dubov <oakad@yahoo.com> wrote:
> 
> > 
> > tifm_sd relies on controller to report the number of successfully
> transferred
> > blocks. Of course, I cannot be sure to what extent the controller is
> > trustworthy. It worked fine until now, though.
> > 
> 
> Sounds like a perfect example of when we have to report 0 upon
> failures. I suspect most controllers will be like this as all the specs
> I've glanced at lack the detail needed to implement a proper sector
> count.
> 
> The problems caused by reporting incorrect values here are extremely
> rare and difficult to provoke, so normal testing is not likely to
> uncover it.
> 

On the other hand, you may remember that in one of the earlier versions of the
driver I actually counted busy/ready cycles during transfer and from what I
remember, it appeared like controller does the right thing - decrements the
page counter at the "not busy" strobe.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ

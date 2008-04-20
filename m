Return-Path: <linux-kernel-owner+w=401wt.eu-S1762614AbYDTCeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762614AbYDTCeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 22:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYDTCeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 22:34:18 -0400
Received: from web36708.mail.mud.yahoo.com ([209.191.85.42]:41911 "HELO
	web36708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752717AbYDTCeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 22:34:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Ojmuv1A1ez7m2thTA2BVTWCkT2Sa5qN07VPdRoUPyBfjp4gCNHPNHrYBsZJUWB4il8sUaaMwGuvL1G2SBtRcP9fMjF2kyf8nnwKhCGgIGplBp0s4bXkX6M0Xt83YytIt9NrLk1XaJl6BYtJJlV15E4UUE1nRrEg0hnIwZlhLVg4=;
X-YMail-OSG: hBdbz_UVM1mJNCZjahMUZfaFVo4DXKR9SLK5eHWbySbFE4O6t5Nug72s7kkkMciVt.meQnuDRlFu1yY_ax9LttDc64GpuMbssluTaNyllqe6_DpONoYW5bDFZw--
Date: Sat, 19 Apr 2008 19:34:12 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [RFC] MMC multiwrite capability removal
To: Pierre Ossman <drzeus-list@drzeus.cx>,
       David Brownell <david-b@pacbell.net>,
       Andrew Victor <linux@maxim.org.za>, Pavel Pisa <ppisa@pikron.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       Anderson Briglia <briglia.anderson@gmail.com>,
       "Syed Mohammed, Khasim" <x0khasim@ti.com>,
       Russell King <rmk@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080419095136.15a50cc9@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <896748.37554.qm@web36708.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> Hi everyone,
> 
> I've been planning to remove the MMC multiwrite capability (making it
> always on), but I need some help from all you driver maintainers first.
> 
> Ages ago, I had a chat with Axboe about the current situation and it
> turns out that the MMC layer is a bit over-cautious. There are plenty
> of other block devices that cannot report anything more than
> success/failure for the whole request. So it's silly that we're
> crippling the MMC layer when upper layers have to deal with that
> scenario anyway.
> 
> What I need from you is and audit of your respective driver(s) and
> check that they do not overestimate the number of successfully written
> blocks. Please send a short reply even if your driver needs no changes.
> 

tifm_sd relies on controller to report the number of successfully transferred
blocks. Of course, I cannot be sure to what extent the controller is
trustworthy. It worked fine until now, though.




      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ

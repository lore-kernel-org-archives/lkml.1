Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbXLRSX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbXLRSX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760784AbXLRSVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:21:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:1638 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763274AbXLRSVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:21:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mYCuNMoffymmDQDjIzEPensnMcIcvzc+s1IjXHIQJ7GFeyi12451PErmq10FaV2eKj4XB4Nz9a3CDTcoHbaAx2sFjHFMkHAEXapdxcGM3EAzFx0tGm5DlBtBXhB78T27Voi2oZZ1Gf/2aqf4dbBmDbOgfMMkbAeBDpwoTGX4Sbk=
Message-ID: <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>
Date: Tue, 18 Dec 2007 13:21:10 -0500
From: "James Nichols" <jamesnichols3@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0712181910580.4422@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
	 <Pine.LNX.4.64.0712180009390.32270@fbirervta.pbzchgretzou.qr>
	 <83a51e120712180734i334399dbl51f44fe32d815f7d@mail.gmail.com>
	 <Pine.LNX.4.64.0712181704380.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712180845k6cadf67bn5dd66fb2d3ac72d4@mail.gmail.com>
	 <Pine.LNX.4.64.0712181818360.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712181009pf954f43mcb63ea4dab638458@mail.gmail.com>
	 <Pine.LNX.4.64.0712181910580.4422@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is a purely hypothethical (and in practice unlikely) idea:
> Java opens up too many sockets (more than you really request) and the
> kernel, for whatever reason, does not deliver packets to programs
> which have maxed out their fds. Well it would already help if the
> java blob was split into multiple blobs (assuming the problem
> persists), as the best testcase is the smallest possible one. So if
> it is reproducable without the web blob, great step there.
>


Right, I don't disagree with you there.  FWIW, I can disable entire
parts of the application and have already narrowed down reproduction
of this issue to the 200 threads that make the webservice calls, so it
doesn't have anything to do with any of the GUI or other background
services that my application executes.


You said:

> Well you could still blame Java. I am sure that if you program was C,
> the problem could be narrowed down much easier.

I'm curious to know how this problem would be easier to narrow down if
it were written in C.

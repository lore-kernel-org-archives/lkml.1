Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbXFYKyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbXFYKyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 06:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbXFYKyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 06:54:39 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:39018 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281AbXFYKyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 06:54:37 -0400
From: Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Date: Mon, 25 Jun 2007 12:54:35 +0200
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Alexander Wuerstlein <snalwuer@cip.informatik.uni-erlangen.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       arw@arw.name
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
Message-ID: <20070625105435.GD24777@faui01.informatik.uni-erlangen.de>
References: <11824417551424-git-send-email-arw@arw.name> <1182446251.2704.0.camel@laptopd505.fenrus.org> <20070621172557.GE9741@cip.informatik.uni-erlangen.de> <1182446983.2704.4.camel@laptopd505.fenrus.org> <20070621174612.GG9741@cip.informatik.uni-erlangen.de> <Pine.LNX.4.64.0706232001070.11964@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706232001070.11964@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> >If a process uses read() it needs some executable and writable memory. We do
> >check for this in mprotect(). There is a problem with the i386-architecture,
> >because it allows execution of any readable page (except with newer
> >processors). But beyond that ugliness of i386, it should not be possible to
> >execute anything without us noticing it (hopefully).
>
> r and x together is not a problem IMHO.

It is, if you would want to have rw but can only get rwx.
regards,
	Johannes

-- 
Johannes Schlumberger                      Department of Computer Science IV
Martensstrasse 1  D-91058 Erlangen Germany  University of Erlangen-Nuremberg
             http://wwwcip.informatik.uni-erlangen.de/~spjsschl

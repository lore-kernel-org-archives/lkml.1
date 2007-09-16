Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbXIPRIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbXIPRIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbXIPRIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:08:17 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1272 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbXIPRIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:08:16 -0400
Date: Sun, 16 Sep 2007 19:07:55 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Matej Laitl <strohel@gmail.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] menuconfig: distinguish between selected-by-another
 options and comments
In-Reply-To: <200709152004.11930.strohel@gmail.com>
Message-ID: <Pine.LNX.4.64.0709161906440.1818@scrub.home>
References: <200709152004.11930.strohel@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811837-936544445-1189962475=:1818"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811837-936544445-1189962475=:1818
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Sat, 15 Sep 2007, Matej Laitl wrote:

> menuconfig currently represents options implied by another option ('selec=
t'
> directive in Kconfig) by prefixing them with '---'. Unfortunately the sam=
e
> notation is used for comments.
>=20
> This patch changes notation of selected-by-another items by introducing 2=
 new
> representations for implied options:
> {*} or {M} for options selected by another modularized one, thus builtin =
or
> module capable,
> -*- or -M- for options that cannot be at the moment changed by user.

I shortly considered doing something like this, but initially I wanted to
keep it simple. It's a compromise between overloading the user interface
with information and keeping it simple. That's the only concern I have
with it, but if everyone else likes I don't mind either. :)

> Signed-off-by: Mat=C4=9Bj Laitl <strohel@gmail.com>

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

bye, Roman
---1463811837-936544445-1189962475=:1818--

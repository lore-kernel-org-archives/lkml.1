Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZBHKJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZBHKJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 05:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZBHKJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 05:09:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZBHKJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 05:09:08 -0500
Date: Sun, 8 Feb 2009 08:08:37 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf@foerster.gmx.de>,
       Gerd Knorr <kraxel@bytesex.org>, hverkuil@xs4all.nl, awalls@radix.net
Subject: Re: 2.6.29-rc3-git3 -- drivers/media/video/cx88/cx88-i2c.c:122:
 error: =?UTF-8?B?4oCYc3RydWN0IGN4ODhfY29yZeKAmQ==?= has no member named
 =?UTF-8?B?4oCYZ2F0ZV9jdHJs4oCZ?=
Message-ID: <20090208080837.7815fca3@caramujo.chehab.org>
In-Reply-To: <a44ae5cd0902021525i28ba9e62jbb87624cc7f6b53d@mail.gmail.com>
References: <a44ae5cd0902021525i28ba9e62jbb87624cc7f6b53d@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009 18:25:22 -0500
Miles Lane <miles.lane@gmail.com> wrote:

> My apologies if I have CCed anyone who I should not have.  I did not
> see a maintainer listed, so am trying the folks listed in the code as
> well as the V4L folks who are responsible for what may be a related
> driver (CX18).
> 
> Previously reported by Toralf Förster for 2.6.29-rc3 ("Subject: Fwd:
> build issue #577 for v2.6.29-rc3"), 2009-01-29 13:08:09.
> 
>   CC [M]  drivers/media/video/cx88/cx88-i2c.o
> drivers/media/video/cx88/cx88-i2c.c: In function 'cx88_call_i2c_clients':
> drivers/media/video/cx88/cx88-i2c.c:122: error: 'struct cx88_core' has
> no member named 'gate_ctrl'
> drivers/media/video/cx88/cx88-i2c.c:123: error: 'struct cx88_core' has
> no member named 'gate_ctrl'
> drivers/media/video/cx88/cx88-i2c.c:127: error: 'struct cx88_core' has
> no member named 'gate_ctrl'
> drivers/media/video/cx88/cx88-i2c.c:128: error: 'struct cx88_core' has
> no member named 'gate_ctrl'
> make[4]: *** [drivers/media/video/cx88/cx88-i2c.o] Error 1

This should be fixed with on rc3-git5 or above.



Cheers,
Mauro

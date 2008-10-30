Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYJ3O0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYJ3O0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYJ3OZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:25:55 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1714 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbYJ3OZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:25:55 -0400
Date: Thu, 30 Oct 2008 15:25:51 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26] OOPS in elv_next_request
Message-ID: <20081030142550.GB11214@vanheusden.com>
References: <20081027090426.GN8318@vanheusden.com> <a8e1da0810272211s4b145bboef26801c3af0d652@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8e1da0810272211s4b145bboef26801c3af0d652@mail.gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Wed Oct 29 12:57:18 CET 2008
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > While running my http://vanheusden.com/pyk/ script (which randomly
> > inserts and removes modules) I triggered the folllowing oops in a 2.6.26
> > kernel on a Celeron 400 (Mendocino):
> >
> > [ 4768.664021] Floppy drive(s): fd0 is 1.44M
...
> > [ 4768.720058] ---[ end trace 6a50caff78c47574 ]---
> > [ 4769.658313] Floppy drive(s): fd0 is 1.44M
> > [ 4789.656060] no cont in shutdown!
> 
> Hi, could you try the attached test patch?  sorry for using attachment
> as there's some problem for my mail client to reply.

As your patch is based on 2.6.27 I compiled the 2.6.27 kernel with it. But
something odd is going on: when 2.6.27 boots, right after the initrd loading
the screen-resolution gets changed or so, so that most text is no longer
visible. Also the system seems to halt. Unfortunately too early for
netconsole to emit the errors.


Folkert van Heusden

-- 
Multitail es una herramienta flexible que permite visualizar los "log
file" y seguir la ejecución de comandos. Permite filtrar, añadir
colores, combinar archivos, la visualización de diferencias (diff-
view), etc.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

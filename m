Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZBDPLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZBDPLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZBDPLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:11:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:41232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZBDPLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:11:21 -0500
Date: Wed, 4 Feb 2009 07:11:36 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel paging request at 0000000000002328
  __d_lookup+0xc8/0x1d0
Message-ID: <20090204071136.2f682dc2@infradead.org>
In-Reply-To: <c4e36d110902040649v3810c96du1c84caa9052ef4c6@mail.gmail.com>
References: <c4e36d110902040649v3810c96du1c84caa9052ef4c6@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 15:49:52 +0100
Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:

> Hi
> 
> Today I've got this ugly oops - my machine T61, 4GB of memory (checked
> with memtest), SMP, C2D
> kernel commit: 33bfad54b58cf05cfe6678c3ec9235d4bc8db4c2
> 
> The only 'strange' thing I've been doing today is testing ext4 and its
> online resize functionality.
> But this oops happened somewhat later - so I'm not really sure whether
> there is some correlation.
> 
> (Full kernel log follows)

if you have CONFIG_DEBUG_INFO enabled, you can run the oops through
http://www.kerneloops.org/download/markup_oops.pl (or
scripts/markup_oops.pl, but the 64 bit support is pending in a
maintainer tree) to turn this into an even better bug report...
... it will show exactly where in the code the oops was.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbXIEUTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbXIEUTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbXIEUTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:19:34 -0400
Received: from barikada.upol.cz ([158.194.242.200]:58719 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbXIEUTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:19:33 -0400
Date: Wed, 5 Sep 2007 22:34:38 +0200
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Message-ID: <20070905203438.GG475@flower.upol.cz>
References: <200709051443.21522.vda.linux@googlemail.com> <E1ISxBz-00040p-EO@flower> <200709051946.12096.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709051946.12096.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 07:46:11PM +0100, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 16:53, Oleg Verych wrote:
> > * Wed, 5 Sep 2007 14:43:21 +0100
> > * User-Agent: KMail/1.9.1
> > >
> > > Build system: section garbage collection for vmlinux
> > 
> > Maybe this is just a test suit to get finish with `make XYZ static`?
> 
> They are vaguely connected in a sense that unused function which is
> not marked static doesn't generate gcc warning, but will be discarded
> by --gc-sections. "make XYZ static" also tends to find them - you make
> function static, you recompile the file, and gcc informs you that
> the function is not used at all!
> 
> This happened to me when I did aic7xxx patches.
> 
> You may yse --print-gc-sections to see the list of discarded sections.

Anyway, this is gccism/binutilizm. That about other possible/future
options?

Give me example, please, why function must be non static if not used.
If usage requires kconfig tuning, then this is a better way to go, than
to adopt yet another GNU/Luxury.
____

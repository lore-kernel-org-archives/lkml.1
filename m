Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbXIEUGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbXIEUGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXIEUG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:06:28 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40991 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbXIEUG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:06:28 -0400
Date: Wed, 5 Sep 2007 22:07:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] build system: section garbage collection for vmlinux
Message-ID: <20070905200750.GA30812@uranus.ravnborg.org>
References: <200709051443.21522.vda.linux@googlemail.com> <200709051447.00774.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709051447.00774.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 02:47:00PM +0100, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 14:43, Denys Vlasenko wrote:
> > These patches fix section names and add
> > CONFIG_DISCARD_UNUSED_SECTIONS. It is not enabled
> > unconditionally because only newest binutils have
> > ld --gc-sections which is stable enough for kernel use.
> > IOW: this is an experimental feature for now.
> 
> Part 1: fix section names over entire source (all arches).
> 
> Patch is big and boring global s/.text.lock/.text_lock/
> type thing.

The normal naming scheme seems to be:
.<usage>.text so in your example it would be: .lock.text
See the naming og init and exit sections (that was renamed
during 2.5 to be compatible with -ffunction-sections).

	Sam

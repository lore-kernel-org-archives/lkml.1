Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYE2LEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYE2LEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYE2LD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:03:59 -0400
Received: from styx.suse.cz ([82.119.242.94]:47110 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179AbYE2LD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:03:58 -0400
Date: Thu, 29 May 2008 13:03:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Ingo Molnar <mingo@elte.hu>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
In-Reply-To: <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0805291303030.6718@jikos.suse.cz>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
 <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008, Jiri Kosina wrote:

> > So I bisected it to:
> > commit 4cc6028d4040f95cdb590a87db478b42b8be0508
> > Author: Jiri Kosina <jkosina@suse.cz>
> > Date:   Wed Feb 6 22:39:44 2008 +0100
> >     brk: check the lower bound properly
> Indeed, this should take CONFIG_COMPAT_BRK into account. Does the patch 
> below fix it? (assuming that you have CONFIG_COMPAT_BRK=y):
> From: Jiri Kosina <jkosina@suse.cz>
> brk: check lower bound properly
[ ... ]

Geert, did you have time to verify that the patch fixes the problem for 
you please?

Thanks,

-- 
Jiri Kosina
SUSE Labs

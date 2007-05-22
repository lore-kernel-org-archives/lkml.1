Return-Path: <linux-kernel-owner+w=401wt.eu-S965663AbXEVPwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbXEVPwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761285AbXEVPwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:52:30 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3124 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758407AbXEVPwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:52:30 -0400
Date: Tue, 22 May 2007 17:52:37 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - scan all Kconfig files
In-Reply-To: <20070521194416.GA3596@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0705221749360.1817@scrub.home>
References: <20070520175203.GA24511@uranus.ravnborg.org>
 <Pine.LNX.4.64.0705210235030.1817@scrub.home> <20070521194416.GA3596@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 21 May 2007, Sam Ravnborg wrote:

> > A simple example would be 
> > help texts, right now they are per symbol, but they should really be per 
> > menu, so archs can provide different help texts for something.
> 
> This one turned out easy.
> I assume what you had in mind was something like the attached.

Yes, but if we change it, we should also add wrapper functions like 
menu_get_help()/menu_has_help() (where menu_get_help() could also return 
some generated text).

bye, Roman

Return-Path: <linux-kernel-owner+w=401wt.eu-S965555AbXBRB5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965555AbXBRB5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 20:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965556AbXBRB5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 20:57:50 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:57640 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965555AbXBRB5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 20:57:49 -0500
Date: Sun, 18 Feb 2007 02:57:26 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Oleg Verych <olecom@flower.upol.cz>
cc: Olaf Hering <olaf@aepfle.de>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: exporting LANG=C (Re: [PATCH] override build timestamp)
In-Reply-To: <E1HIGE5-0003WZ-Ew@flower>
Message-ID: <Pine.LNX.4.64.0702180250350.14458@scrub.home>
References: <20070216215213.GA10732@aepfle.de> <E1HIGE5-0003WZ-Ew@flower>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 17 Feb 2007, Oleg Verych wrote:

> could you make separate patch with exporting 'LANG=C' on the very
> beginning and delete all other occurrences of it? It's a C header file
> generation and afaik, it must be ASCII.

Bad idea, most user output should be localized (even if it's only utf-8) 
and some kconfig targets have explicit locale support.

bye, Roman

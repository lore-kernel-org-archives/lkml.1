Return-Path: <linux-kernel-owner+w=401wt.eu-S1750733AbXBRDs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750733AbXBRDs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 22:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXBRDs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 22:48:59 -0500
Received: from raven.upol.cz ([158.194.120.4]:64667 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbXBRDs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 22:48:58 -0500
Date: Sun, 18 Feb 2007 04:57:54 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Olaf Hering <olaf@aepfle.de>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: exporting LANG=C (Re: [PATCH] override build timestamp)
Message-ID: <20070218035754.GA17478@flower.upol.cz>
References: <20070216215213.GA10732@aepfle.de> <E1HIGE5-0003WZ-Ew@flower> <Pine.LNX.4.64.0702180250350.14458@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702180250350.14458@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 02:57:26AM +0100, Roman Zippel wrote:
> Hi,

Hallo, Roman.

> On Sat, 17 Feb 2007, Oleg Verych wrote:
> 
> > could you make separate patch with exporting 'LANG=C' on the very
> > beginning and delete all other occurrences of it? It's a C header file
> > generation and afaik, it must be ASCII.
> 
> Bad idea, most user output should be localized (even if it's only utf-8) 
> and some kconfig targets have explicit locale support.

Ok, then maybe this one

<http://marc.theaimsgroup.com/?l=linux-mm-commits&m=116720464804613&w=2>

can be fixed as well? I used same reasoning to comment on it (that
particular patch was dropped).
____

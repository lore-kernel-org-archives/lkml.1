Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbXFEPAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbXFEPAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932497AbXFEO7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:59:52 -0400
Received: from raven.upol.cz ([158.194.120.4]:45678 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbXFEO7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:59:51 -0400
Date: Tue, 5 Jun 2007 17:11:01 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kbuild-devel] [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
Message-ID: <20070605151101.GQ7266@flower.upol.cz>
References: <20070603204700.GH9240@uranus.ravnborg.org> <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org> <20070605133834.GO7266@flower.upol.cz> <20070605141254.GA24722@uranus.ravnborg.org> <20070605145759.GP7266@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605145759.GP7266@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 04:57:59PM +0200, Oleg Verych wrote:
[]
> expand | while read line
> do case "$line" in
>    ++*) echo "$line";;
>    $p*)	[ ${#line} -gt $w79 ] && : ${long:=line}
> 	echo "$line" | sed "/^$p/{s_ *\$__;s_^$p$s7${s}_$p${t}_;s_$s7 _${t}_g}"
> 	;;
>      *) echo "$line";;
>    esac
> done
> [ -n "$long" ] && echo "at least one line, wider than $w79 chars, found" 1>&2
> 
> -*-
[]
> Last -- bark, if there is at least one line longer that w79.

Well, if test will be in the pipe end, i.e. ... | { while; test lingth; }
____


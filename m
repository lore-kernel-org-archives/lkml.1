Return-Path: <linux-kernel-owner+w=401wt.eu-S1750943AbXAXQLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943AbXAXQLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXAXQLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:11:54 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:21360 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbXAXQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:11:53 -0500
Date: Wed, 24 Jan 2007 08:06:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Horst Schirmeier <horst@schirmeier.com>, Andi Kleen <ak@suse.de>,
       Valdis.Kletnieks@vt.edu, Jan Beulich <jbeulich@novell.com>,
       dsd@gentoo.org, kernel@gentoo.org, draconx@gmail.com,
       jpdenheijer@gmail.com, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] kbuild: improving option checking (Re: [PATCH -mm]
 replacement for broken kbuild-dont-put-temp-files-in-the-source-tree.patch)
Message-Id: <20070124080610.0969a15f.randy.dunlap@oracle.com>
In-Reply-To: <20070124085430.GA8160@flower.upol.cz>
References: <20061029120858.GB3491@quickstop.soohrt.org>
	<slrnekcu6m.2vm.olecom@flower.upol.cz>
	<20061031001235.GE2933@quickstop.soohrt.org>
	<200610310119.10567.ak@suse.de>
	<20061031011416.GG2933@quickstop.soohrt.org>
	<20061031135136.GB16063@flower.upol.cz>
	<20070124085430.GA8160@flower.upol.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007 08:54:30 +0000 Oleg Verych wrote:

> Hallo. Tmpfiles, root users, external mod-builds again.
> 
> Kind of fix has finally landed. Instead for `O=/$dir' a patch...
> 
> Anyway i whould like propose my solution of:
> -- external modules build without KBUILD_OUTPUT set;
> -- /dev/null, GNU binutils and root users;
> -- beauty;
> ---
> 
> --- linux~2.6.20-rc5/scripts/Kbuild.include~blackhole-4-tmpfiles	2007-01-12 19:54:26.000000000 +0100
> +++ linux~2.6.20-rc5/scripts/Kbuild.include	2007-01-24 09:19:01.386426000 +0100
> @@ -2,5 +2,5 @@
>  # kbuild: Generic definitions
>  
> -# Convinient variables
> +# Convinient constants

     Convenient

---
~Randy

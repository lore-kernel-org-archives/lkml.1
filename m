Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbZGRHVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbZGRHVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 03:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZGRHVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 03:21:50 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:48028 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZGRHVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 03:21:49 -0400
Date: Sat, 18 Jul 2009 09:21:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Cheng Renquan <crq@kernel.org>
Cc: linux-kbuild@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, crquan@gmail.com,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 0/6] kbuild configuration system improvements
Message-ID: <20090718072138.GA7711@merkur.ravnborg.org>
References: <1247386308-19628-1-git-send-email-crq@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247386308-19628-1-git-send-email-crq@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 04:11:42PM +0800, Cheng Renquan wrote:
> From: Cheng Renquan <crquan@gmail.com>
> 
> These patches improve usability of kernel configuration system,
> 
> 1. add symbol's value shown accompanied in config item's help message;
> 2. move the real plumbing functions code from mconf.c to menu.c, make them
>    be able to be shared with other configuration methods;
> 3. add "symbol's value shown" support for gconfig/xconfig/config;
> 
>     0001-add-symbol-value-to-help-find-the-real-depend.patch
>     0002-add-menu_get_ext_help-function-to-display-more-infor.patch
>     0003-menuconfig-improvements.patch
>     0004-make-use-of-menu_get_ext_help-in-gconfig.patch
>     0005-make-use-of-menu_get_ext_help-in-qconfig.patch
>     0006-make-use-of-menu_get_ext_help-in-make-config.patch

I fixed them all up to:
1) include "kconfig:" prefix in subject
2) cc: of Roman Zippel which is kconfig maintainer

There were a few checkpatch issues that I decided to ignore for now.

Please always cc: Roman on kconfig patches as he is the mintainer.

Applied to kbuild-next.git.

Thanks,
	Sam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbYD3Nzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbYD3Nzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYD3Nzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:55:42 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:37570 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYD3Nzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:55:41 -0400
Message-ID: <48187A2E.8030502@freescale.com>
Date: Wed, 30 Apr 2008 08:54:54 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Tony Breeds <tony@bakeyournoodle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
References: <481529B6.6030802@freescale.com> <20080428015151.GW20457@bakeyournoodle.com> <481739BF.8010305@freescale.com> <20080429164535.GB18018@uranus.ravnborg.org> <20080429172057.GN5882@ZenIV.linux.org.uk> <20080429180601.GA19652@uranus.ravnborg.org>
In-Reply-To: <20080429180601.GA19652@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> Good grief, folks...
> 
> Thanks Al.
> I've queued up the following patch.
> 
> 	Sam
> 
> commit c99cc32e0d92f5fdbdd39a7f42cfff869062fff5
> Author: Sam Ravnborg <sam@uranus.ravnborg.org>
> Date:   Tue Apr 29 20:02:44 2008 +0200
> 
>     kconfig: made check-lxdialog more portable
>     
>     OS-X shell did not like 'echo -e' so implement
>     suggestion from Al Viro to use a more portable construct.
>     
>     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>     Cc: Al Viro <viro@ZenIV.linux.org.uk>

Just for the record:

Acked-By: Timur Tabi <timur@freescale.com>

This works on OS X.  I haven't tested it on Linux, though.

FYI, there are other issues that break cross-compiling from OS X, but none of
them are related to /bin/sh.  I'll post patches for those later this week.

-- 
Timur Tabi
Linux kernel developer at Freescale

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbZGIQ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbZGIQ2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760309AbZGIQ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:28:13 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43866 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410AbZGIQ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:28:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tB2nmWjnc8nHeRnEOo641UwCQju+ghmXx6lWOdRNeY/hu5aR9p+pGxISAcWHVD9+YG
         GLkwUkvav/5r+SFVDsdezbdnz4EgHVdx8QEkga8AWBgoViaHFG5q79Qhhrcm8ep7VDYu
         ekWAQbG29T7zloQBDrzBWuGljVoJlY8EV/HRY=
Date: Thu, 9 Jul 2009 20:28:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 20/44] includecheck fix: x86, shadow.c
Message-ID: <20090709162807.GD5208@lenovo>
References: <1247063308.4382.12.camel@ht.satnam> <1247065179.4382.51.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247065179.4382.51.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jaswinder Singh Rajput - Wed, Jul 08, 2009 at 08:29:39PM +0530]
| 
| fix the following 'make includecheck' warning:
| 
|   arch/x86/mm/kmemcheck/shadow.c: linux/module.h is included more than once.
| 
| Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
| ---
|  arch/x86/mm/kmemcheck/shadow.c |    1 -
|  1 files changed, 0 insertions(+), 1 deletions(-)
| 
| diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
| index e773b6b..3f66b82 100644
| --- a/arch/x86/mm/kmemcheck/shadow.c
| +++ b/arch/x86/mm/kmemcheck/shadow.c
| @@ -1,7 +1,6 @@
|  #include <linux/kmemcheck.h>
|  #include <linux/module.h>
|  #include <linux/mm.h>
| -#include <linux/module.h>
|  
|  #include <asm/page.h>
|  #include <asm/pgtable.h>
| -- 
| 1.6.0.6
|

Better to CC Vegard on this.
 
	-- Cyrill

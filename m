Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYK1EZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYK1EZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYK1EZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:25:30 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:36419 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYK1EZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:25:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xwsYLBn9/HUTVnKj+EVwo090ZImbLRmbHvUWcxTo/Iz+vhqFUqyv1gdY4VfH174dbK
         I8s2m5/UVXuyS6D22DnQS9M4QvjgUMBZzTnxyfi0yH1gzx9oHX42/N3UINuO+R0BumYC
         +pCj6tojgFlR0GP4VwZd+x/F/qVCWUi90EH04=
Subject: Re: [git pull] drm fixes for 2.6.28 final
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0811280325110.25353@skynet.skynet.ie>
References: <alpine.DEB.2.00.0811280325110.25353@skynet.skynet.ie>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 20:25:27 -0800
Message-Id: <1227846327.5880.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 03:26 +0000, Dave Airlie wrote:
> Hi Linus,
> 
> Please pull the 'drm-fixes' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes
> 
> This larger than we wished patch, fixes a number of regressions reported.
> 
> 1. vblank rework causes hangs on VT switch - fixes touches all drivers.
> 2. i915 irq/msi code had various issues on various hw - including a screaming
> IRQ.
> 3. a suspend/resume regression on intel hw with DRI2 userspace.
> 4. A BUG_ON being hit.

I can confirm this fixes suspend/resume for me:

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)

Thanks a lot guys.

Harvey


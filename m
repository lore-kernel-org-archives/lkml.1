Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYGJPEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYGJPEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbYGJPDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:03:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44410 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbYGJPDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:03:53 -0400
Date: Thu, 10 Jul 2008 13:35:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, jikos@suse.cz
Subject: Re: [PATCH -mm 4/8] serio: Speed-up resume
Message-ID: <20080710113535.GD15412@elf.ucw.cz>
References: <200807100152.17755.rjw@sisk.pl> <200807100201.56232.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807100201.56232.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-07-10 02:01:55, Rafael J. Wysocki wrote:
> From: Shaohua Li <shaohua.li@intel.com>
> Subject: serio: Speed-up resume
> 
> serio_resume will call into psmouse_extensions(). In my test, the
> routine is very slow, it blocks resume about 1 sec. Below patch (move
> resume to kseriod, just like boot time probe) cures the issue in my
> test, and seems no side effect. I'm no familiar with serio driver, so
> please check. 
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Acked-by: Len Brown <lenb@kernel.org>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Cc: Jiri Kosina <jikos@suse.cz>

ACK from me, but I'm not a serio expert.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

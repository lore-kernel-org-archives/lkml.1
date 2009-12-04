Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZLDOkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZLDOkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZLDOkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:40:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51954 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbZLDOkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:40:37 -0500
Date: Fri, 4 Dec 2009 09:04:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-laptop@vger.kernel.org
Subject: Re: [PATCH v7 4/8] Loongson: YeeLoong: add battery driver
Message-ID: <20091204080408.GA1540@ucw.cz>
References: <cover.1259932036.git.wuzhangjin@gmail.com> <059fa216d70771a6341edb2db4cc559e958273e9.1259932036.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <059fa216d70771a6341edb2db4cc559e958273e9.1259932036.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-04 21:34:17, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> This patch adds APM emulated Battery Driver, it provides standard
> interface(/proc/apm) for user-space applications(e.g. kpowersave,
> gnome-power-manager) to manage the battery.

It would be nicer if this went to drivers/power, and used its
interface -- providing not only percentage but also other values.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

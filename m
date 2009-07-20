Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbZGTKEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbZGTKEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 06:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbZGTKEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 06:04:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60086 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZGTKEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 06:04:06 -0400
Date: Mon, 20 Jul 2009 12:03:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Use common localtime/gmtime in
	fat_time_unix2fat()
Message-ID: <20090720100359.GC19341@elf.ucw.cz>
References: <4A5C3BC0.6020701@cn.fujitsu.com> <20090714151040.b7b3b26d.akpm@linux-foundation.org> <20090718115019.GH1433@ucw.cz> <04e101ca08e5$be078fa0$808410ac@zhaoleiwin> <20090719202018.497f7ec1.akpm@linux-foundation.org> <4A643EFE.7090103@cn.fujitsu.com> <4A643F82.5020108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A643F82.5020108@cn.fujitsu.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-07-20 17:57:22, Zhaolei wrote:
> It is not necessary to write custom code for convert calendar time
> to broken-down time.
> localtime()/gmtime() is more generic to do that.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

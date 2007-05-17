Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbXEQVfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbXEQVfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbXEQVfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:35:04 -0400
Received: from lazybastard.de ([212.112.238.170]:60221 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbXEQVfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:35:01 -0400
Date: Thu, 17 May 2007 23:30:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070517213038.GF15676@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <200705171708.53038.arnd@arndb.de> <20070517202139.GD15676@lazybastard.org> <200705172300.21694.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705172300.21694.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 23:00:20 +0200, Arnd Bergmann wrote:
> 
> Just using nanoseconds probably doesn't gain you much after all
> then. You could however just have separate 32 bit fields in the
> inode for seconds and nanoseconds, that will result in the exact
> same layout that you have right now, but won't require a conversion
> function.

I could also have a 30bit and a 34bit field.  30bit is enough for
nanoseconds.  So many options.

Jörn

-- 
Time? What's that? Time is only worth what you do with it.
-- Theo de Raadt

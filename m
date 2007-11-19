Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbXKSFYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbXKSFYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 00:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbXKSFYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 00:24:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48732 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXKSFYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 00:24:40 -0500
Date: Sun, 18 Nov 2007 21:22:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, akpm@linux-foundation.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH][retry-2] init: Introduce rootdir bootparm to select
 which dir to sys_chroot
Message-ID: <20071118212215.002fcd8b@laptopd505.fenrus.org>
In-Reply-To: <200711182009.19072.a1426z@gawab.com>
References: <200711182009.19072.a1426z@gawab.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007 20:09:19 +0300
Al Boldi <a1426z@gawab.com> wrote:

> 
> Second try; this time with a doc-update, and the ability to remount
> normally.


Hi,

to be honest, this is something that really should be done in the
initramfs image; we should strive to keep the more complex bootup
scenarios there and not inside the kernel bootup code...

Greetings,
   Arjan van de Ven

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

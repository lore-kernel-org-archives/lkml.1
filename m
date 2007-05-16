Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbXEPPuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbXEPPuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762279AbXEPPuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:50:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33234 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762061AbXEPPuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:50:16 -0400
Subject: Re: [PATCH] LogFS take three
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
In-Reply-To: <20070516083408.dcd9dd78.akpm@linux-foundation.org>
References: <20070515151919.GA32510@lazybastard.org>
	 <20070515133759.9ee434a2.akpm@linux-foundation.org>
	 <1179317240.2859.222.camel@shinybook.infradead.org>
	 <20070516083408.dcd9dd78.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 16 May 2007 23:49:55 +0800
Message-Id: <1179330596.2859.248.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 08:34 -0700, Andrew Morton wrote:
> Reduced testability, mainly. Also potentially reduced usefulness. 

CONFIG_MTD has never been a barrier to testability. JFFS2 depends on MTD
and had _most_ of its early testing and development done on the 'fake'
mtdram device.

Utility is a factor of the underlying design -- a filesystem designed
for flash really isn't suited to block devices.

-- 
dwmw2


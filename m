Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbYEWPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbYEWPMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYEWPMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:12:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59961 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYEWPMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:12:00 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel image
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20080523155610.2ec5ffd0@core>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <20080523155610.2ec5ffd0@core>
Content-Type: text/plain
Date: Fri, 23 May 2008 16:11:56 +0100
Message-Id: <1211555516.28967.30.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 15:56 +0100, Alan Cox wrote:
> > A third set of drivers already use the firmware loader, but can't be
> > used without help from userspace, which sometimes requires an initrd.
> > This allows them to work in a static kernel.
> 
> This makes a lot of sense to me - its small, clean and while I don't
> think its relevant to the PC world it has real clear advantages to the
> embedded space.
> 
> For the embedded case isn't either compressing the firmware or not doing
> the vmalloc/copy worth the effort however ?

For avoiding the vmalloc/copy see my earlier response.

Adding compression would be cute; I did think about that but figured it
could wait for later (actually I think at the time I meant "later" to be
today too, but then I forgot :)

-- 
dwmw2


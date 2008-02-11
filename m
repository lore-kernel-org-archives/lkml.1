Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbYBKRCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbYBKRCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbYBKRCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:02:14 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41352 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758227AbYBKRCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:02:11 -0500
Subject: Re: [SCSI] ses: fix memory leaks
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       kristen.c.accardi@intel.com
In-Reply-To: <1202747000.3122.28.camel@localhost.localdomain>
References: <200802090413.53275.yinghai.lu@sun.com>
	 <200802091515.48076.yinghai.lu@sun.com>
	 <1202704118.3136.79.camel@localhost.localdomain>
	 <200802102325.26538.yinghai.lu@sun.com>
	 <1202747000.3122.28.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 11:02:06 -0600
Message-Id: <1202749326.3122.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 10:23 -0600, James Bottomley wrote:
> On Sun, 2008-02-10 at 23:25 -0800, Yinghai Lu wrote:
> > please check it...
> 
> This one looks perfect, thanks!

Well, nearly perfect.  I corrected this typo:

+       if (!buf)
+               goto simple_polulate;
                            ^^^^^^^^

Which a compile check before you submitted the patch would have picked
up ...

James



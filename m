Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYE2Ebg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYE2Ebg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 00:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYE2EbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 00:31:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61847 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYE2EbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 00:31:23 -0400
Message-ID: <483E313A.9040905@cn.fujitsu.com>
Date: Thu, 29 May 2008 12:29:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [BUG ?] kmalloc() with GFP_KERNEL while holding spinlock ?
References: <483E2156.9020108@cn.fujitsu.com> <87fxs1rcag.fsf@saeurebad.de>
In-Reply-To: <87fxs1rcag.fsf@saeurebad.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Fixed by commit ae6c23c4e1ec9720b99e1e6850fe47c6c7fddbb3 "Fixups to ATA
> ACPI hotplug" by Matthew Garrett.
> 

Thanks. The code I was reading is 2.6.26-rc2-mm1. I should have checked the
latest kernel.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553Ab0A2BOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0A2BOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 20:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855Ab0A2BOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 20:14:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62974 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab0A2BOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 20:14:09 -0500
Message-ID: <4B62366E.6040207@cn.fujitsu.com>
Date: Fri, 29 Jan 2010 09:14:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] tip tree - No irq handler for vector (irq -1)
References: <4B6143C5.7060602@cn.fujitsu.com> <1264709113.2849.14.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1264709113.2849.14.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> Zefan,
> 
> I have posted a fix for this.
> 
> http://marc.info/?l=linux-kernel&m=126420641021426&w=2
> 
> Can you please check if this indeed fixes your issue?
> 

Yes, it works. Thanks!

But I still saw this:

do_IRQ: 1.48 No irq handler for vector (irq -1)

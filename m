Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231Ab0AGIy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0AGIy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264Ab0AGIy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:54:27 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:58960 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab0AGIy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:54:26 -0500
Date: Thu, 7 Jan 2010 14:24:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH -mmotm] memcg: implement memory thresholds document fixes
Message-ID: <20100107085419.GV3059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
 <20100107095714.9edc4201.nishimura@mxp.nes.nec.co.jp>
 <20100107101805.b26a1f1a.kamezawa.hiroyu@jp.fujitsu.com>
 <20100107103417.58677878.nishimura@mxp.nes.nec.co.jp>
 <20100107104018.6fdb2f79.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100107104018.6fdb2f79.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-07 10:40:18]:

> > (My biggest concern now is the influence of transparent hugepage to vm and memcg.)
> > 
> Yes, it's interesting challenge but has concerns for us ;)
>

Yes, I agree. I spoke to Andrea and he said that transparent pages
should not affect us much directly. He also added support for memcg,
but this is definitely something we should watch for. 

-- 
	Balbir

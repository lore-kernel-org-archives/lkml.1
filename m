Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbZGXDEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbZGXDEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZGXDEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:04:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62848 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZGXDEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:04:04 -0400
Message-ID: <4A692444.2030303@cn.fujitsu.com>
Date: Fri, 24 Jul 2009 11:02:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com, xiyou.wangcong@gmail.com,
       kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, bblum@google.com
Subject: Re: [RFC][PATCH] flexible array implementation v4
References: <20090723152647.D9391722@kernel>
In-Reply-To: <20090723152647.D9391722@kernel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> Remaining issues:
> - How should we deal with out-of-range indexes, especially
>   in flex_array_get() which returns void*?  ERR_PTR()?
>   BUG_ON()?  return NULL (current behavior)?
> - Should care be taken not to allow a flex_array_get() to
>   an index where no flex_array_put() was done?
> - Should we decay further than just packing things into the
>   'base' page?  Should we actually kmalloc() less than a
>   page at times when it will fit?
> 

I sugguest find some candidate users and see how this flex_array
fits them.


Return-Path: <linux-kernel-owner+w=401wt.eu-S933443AbZHEFjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443AbZHEFjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 01:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZHEFjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 01:39:52 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39495 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZHEFjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 01:39:51 -0400
X-AuditID: b753bd60-ab846ba000006009-35-4a791b235c47
Message-ID: <4A791AF6.3040902@hitachi.com>
Date: Wed, 05 Aug 2009 14:39:02 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: npiggin@suse.de, riel@redhat.com, akpm@linux-foundation.org,
       linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [12/15] HWPOISON: The high level memory error handler in
    the VM v7
References: <200908041152.240876191@firstfloor.org> 
    <20090804215311.5D5A0B15D8@basil.firstfloor.org>
In-Reply-To: <20090804215311.5D5A0B15D8@basil.firstfloor.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andi Kleen wrote:

> +	 * Truncation is a bit tricky. Enable it per file system for now.
> +	 */
> +	if (mapping->a_ops->error_remove_page) {
> +		err = mapping->a_ops->error_remove_page(mapping, p);

I couldn't find the definition of error_remove_page in
address_space_operations.  Didn't you miss sending a patch?

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


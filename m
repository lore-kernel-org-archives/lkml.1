Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYIHX57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYIHX57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYIHX5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:57:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYIHX5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:57:51 -0400
Message-ID: <48C5BBEC.5060405@zytor.com>
Date: Mon, 08 Sep 2008 16:57:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keiichiro Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: ifdef Quicklists in /proc/meminfo
References: <Pine.LNX.4.64.0809081351240.4983@blonde.site> <20080909084241.41A0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080909084241.41A0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> A "Quicklists:          0 kB" line has just started appearing in
>> /proc/meminfo, but most architectures (including x86) don't have
>> them configured: may we please #ifdef it, like the highmem lines?
>>
>> And those architectures which do have quicklists configured are
>> using them for page tables: so let's place it next to PageTables.
>>
>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
>> ---
> 
> Oh, I see.
> Thanks Hugh.
> 
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

x86 *does* use quicklists, at least with PAE.

	-hpa

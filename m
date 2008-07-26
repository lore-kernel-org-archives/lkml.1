Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYGZHy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYGZHy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 03:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYGZHyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 03:54:22 -0400
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:35311 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYGZHyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 03:54:21 -0400
Message-ID: <488AD829.2080600@numericable.fr>
Date: Sat, 26 Jul 2008 09:54:17 +0200
From: Eric ROMMELFANGEN <eric.rommelfangen@numericable.fr>
User-Agent: Thunderbird 3.0a1 (X11/2008051919)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [>=2.6.26-git9]general protection fault in PREEMPT SMP when	downloading
References: <488A4FB4.8090602@numericable.fr> <20080725224410.GA5345@martell.zuzino.mipt.ru>
In-Reply-To: <20080725224410.GA5345@martell.zuzino.mipt.ru>
Content-Type: multipart/mixed;
 boundary="------------010505080204010705030507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010505080204010705030507
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Alexey Dobriyan wrote:
> On Sat, Jul 26, 2008 at 12:12:04AM +0200, Eric ROMMELFANGEN wrote:
>    
>> Since 2.6.26-git9 kernel, I have this protection fault when downloading
>> files with ftp or http protocol :
>> ...
>> trying to fetch "http:www..."
>> general protection fault : 0000 [1] PREEMPT SMP
>> CPU1
>> Modules linked in: iptables_raw xt_comment xt_policy ipt_ULOG ipt_TTL ...
>>
>> I attach my .config.
>>
>> Could someone tells me what the matter with this error ?
>>      
>
> No, unless you post full protection fault message not just start of it.
>
>
>    
hi Alexey,


I found a patch in this post which seems to solve my bug :

http://lkml.org/lkml/2008/7/24/186

I am going to test it more and sorry for the noise.

Thanks.

--------------010505080204010705030507
Content-Type: text/x-vcard; charset=utf-8;
 name="eric_rommelfangen.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="eric_rommelfangen.vcf"

YmVnaW46dmNhcmQNCmZuOkVyaWMgUk9NTUVMRkFOR0VODQpuOlJPTU1FTEZBTkdFTjtFcmlj
DQphZHI7cXVvdGVkLXByaW50YWJsZTpBcHBhcnRlbWVudCA3Mzs7NDM0LCBhdmVudWUgQW5k
cj1DMz1BOSBNYWxyYXV4O1ZJTExFUlMtTEVTLU5BTkNZOzs1NDYwMDtGUkFOQ0UNCmVtYWls
O2ludGVybmV0OmVyaWMucm9tbWVsZmFuZ2VuQG51bWVyaWNhYmxlLmZyDQp0ZWw7d29yazow
My44My40Ny4wMC42NS4gKHN0YW5kYXJkKQ0KdGVsO2ZheDowMy44My40Ny4yNy45NC4gKHBy
b2Zlc3Npb25uZWwpDQp0ZWw7aG9tZTowMy41NS4yMC44NS43NS4NCnRlbDtjZWxsOjA2LjM1
LjU1LjA5LjEzLg0Kbm90ZTtxdW90ZWQtcHJpbnRhYmxlOm1hY2hpbmUgeDg2XzY0IEFNRCBB
dGhsb24odG0pIDY0IFgyIER1YWwgQ29yZSBQcm9jZXNzb3IgNjAwMCsgQXV0aGVudGljQU09
DQoJRCBHTlUvTGludXggc291cyBHZW50b28gTGludXggfmFtZDY0IChrZXJuZWwtdmFuaWxs
YS0yLjYuMjYtcmNYKT0wRD0wQT0NCgkqIGNsaWVudCBkZSBtZXNzYWdlcmllIDogTW96aWxs
YSBUaHVuZGVyYmlyZCAzLjBhMT0wRD0wQT0NCglBZmluIGRlIGZhdm9yaXNlciBsZSBkPUMz
PUE5dmVsb3BwZW1lbnQgZGUgbCdpbnRlcm9wPUMzPUE5cmFiaWxpdD1DMz1BOWRlPQ0KCXMg
c3lzdD1DMz1BOG1lcyBkJ2luZm9ybWF0aW9uLCBtZXJjaSBkJ3V0aWxpc2VyLCBkYW5zIGxh
IG1lc3VyZSBkZSB2b3Nwb3M9DQoJc2liaWxpdD1DMz1BOXMgdGVjaG5pcXVlcyBldCBtYXQ9
QzM9QTlyaWVsbGVzLCBkZXMgZm9ybWF0cyBkZSBmaWNoaWVyc291dj0NCgllcnRzIGV0IHN0
YW5kYXJkaXM9QzM9QTlzIChmaWNoaWVycyBidXJlYXV0aXF1ZXMgYXUgZm9ybWF0IHJ0Ziwg
Lm9kdCBvdS54PQ0KCW1sLCBmaWNoaWVycyBpbWFnZXMgYXUgZm9ybWF0IC5qcGVnLCAuLi4p
Lg0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnVybDp3d3cuZ2VudG9vLm9yZw0KdmVyc2lvbjoy
LjENCmVuZDp2Y2FyZA0KDQo=
--------------010505080204010705030507--

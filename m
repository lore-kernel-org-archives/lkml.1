Return-Path: <linux-kernel-owner+w=401wt.eu-S932288Ab0A1S7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab0A1S7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240Ab0A1S7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:59:31 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:30282 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0A1S7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:59:31 -0500
Message-ID: <4B61DD2C.8020201@oracle.com>
Date: Thu, 28 Jan 2010 10:53:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, richard.rojfors@pelagicore.com
Subject: Re: mmotm 2010-01-28-01-36 uploaded (media/radio/saa7706h.c)
References: <201001281002.o0SA2G0k002220@imap1.linux-foundation.org>
In-Reply-To: <201001281002.o0SA2G0k002220@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B61DD46.0003:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/10 01:36, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-01-28-01-36 has been uploaded to
>
>     http://userweb.kernel.org/~akpm/mmotm/
>
> and will soon be available at
>
>     git://zen-kernel.org/kernel/mmotm.git
>
> It contains the following patches against 2.6.33-rc5:


This driver needs to #include <linux/delay.h>:

drivers/media/radio/saa7706h.c:220: error: implicit declaration of function 'msleep'


-- 
~Randy

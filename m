Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYE1BAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYE1BAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbYE1BAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:00:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58284 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbYE1BAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:00:03 -0400
Message-ID: <483CAE30.7080707@cn.fujitsu.com>
Date: Wed, 28 May 2008 08:58:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, video4linux-list@redhat.com
Subject: Re: [PATCH] dvb-usb/gp8psk.c: return -errno rather than errno
References: <483BBFD1.3090204@cn.fujitsu.com> <20080527120303.639a5d04@gaivota>
In-Reply-To: <20080527120303.639a5d04@gaivota>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> On Tue, 27 May 2008 16:01:21 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> gp8psk_power_ctrl() returns -EINVAL in some failing paths, but
>> returns EINVAL in some other paths.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.cn>
>> ---
> Thanks Li. However, I've committed a few days ago a similar patch from Marcin.
> 

Good to know this. :)

> 
> Cheers,
> Mauro
> 
> 

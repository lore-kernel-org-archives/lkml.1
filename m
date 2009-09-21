Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZIULau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZIULau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZIULat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:30:49 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:65364 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbZIULat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:30:49 -0400
MIME-Version: 1.0
In-Reply-To: <4AB74956.8070708@nokia.com>
References: <2f6c0105e623b9134adbb2e849e8074722903fb9.1253530731.git.kirill@shutemov.name>
	 <4AB74956.8070708@nokia.com>
Date: Mon, 21 Sep 2009 14:30:52 +0300
Message-ID: <cc557aab0909210430i6f016c60s89f276b662f01501@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Russell King <linux@arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 12:37 PM, Aaro Koskinen <aaro.koskinen@nokia.com> wrote:
> Hi,
>
> Kirill A. Shutemov wrote:
>>
>> It needed for proper prefetch abort handling on ARMv7.
>>
>> Instruction fault status register (IFSR) was introduced on ARMv7.
>
> According to the ARMv7-AR reference manual it's available in ARMv6
> (see chapter G.7).

You are right. I'll fix my patch.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZJAHPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZJAHPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbZJAHPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:15:35 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:54508 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbZJAHPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:15:34 -0400
MIME-Version: 1.0
In-Reply-To: <b833952fedbf24c4a16e0d79fe78019357e9652b.1253781660.git.kirill@shutemov.name>
References: <b833952fedbf24c4a16e0d79fe78019357e9652b.1253781660.git.kirill@shutemov.name>
Date: Thu, 1 Oct 2009 10:15:38 +0300
Message-ID: <cc557aab0910010015i2e471c13mb4529409b3e68e45@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Koskinen Aaro <aaro.koskinen@nokia.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 11:49 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> Instruction fault status register, IFSR, was introduced on ARMv6 to
> provide status information about the last insturction fault. It
> needed for proper prefetch abort handling.
>
> Now we have three prefetch abort model:
>
>  * legacy - for CPUs before ARMv6. They doesn't provide neither
>    IFSR nor IFAR. We simulate IFSR with section translation fault
>    status for them to generalize code;
>  * ARMv6 - provides IFSR, but not IFAR;
>  * ARMv7 - provides both IFSR and IFAR.
>
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Any chances to get it into 2.6.32?

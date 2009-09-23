Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZIWLsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZIWLsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZIWLsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:48:13 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:59143 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZIWLsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:48:12 -0400
MIME-Version: 1.0
In-Reply-To: <00ae0c0830ca659709d80e56e8e87b636c32fcf6.1253616961.git.kirill@shutemov.name>
References: <00ae0c0830ca659709d80e56e8e87b636c32fcf6.1253616961.git.kirill@shutemov.name>
Date: Wed, 23 Sep 2009 14:48:16 +0300
Message-ID: <cc557aab0909230448r6a4ff709k8720155d9389ceae@mail.gmail.com>
Subject: Re: [PATCH v4, REBASED 1/2] ARM: Pass IFSR register to 
	do_PrefetchAbort()
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

On Tue, Sep 22, 2009 at 2:00 PM, Kirill A. Shutemov
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

Any feedback?

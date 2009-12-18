Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZLRB26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZLRB26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZLRB24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:28:56 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40935 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZLRB2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:28:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TzLn82XUE4UvMQLnPWKrEMr4IBbnpW0kINJ5Gl0jGK+/KKJO6Jb0Xaj6KxvFQVe/4Z
         b8OcXL9BS/jZIuEMpAsoelZ3pPeTm9nQEBNh/d3g49gUSz23SEHLeBgKSH4l3jhx51Z/
         NOmPmMLq402nOuu5Pw8hSV8RgKqAKRjDPmeMU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912161453480.10371@localhost.localdomain>
References: <alpine.LFD.2.00.0912161453480.10371@localhost.localdomain>
Date: Thu, 17 Dec 2009 17:28:50 -0800
X-Google-Sender-Auth: 44139bd396519038
Message-ID: <86802c440912171728s27dd7108k85a0f1563660c95b@mail.gmail.com>
Subject: Re: [git pull request] ACPI and driver patches for 2.6.33.merge
From: Yinghai Lu <yinghai@kernel.org>
To: Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "Barnes, Jesse" <jesse.barnes@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 12:06 PM, Len Brown <lenb@kernel.org> wrote:
> Hi Linus,
>
> please pull from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
>
;..
>
> Shaohua Li (3):
>      ACPI: Add a generic API for _OSC -v2
>      ACPI: cleanup pci_root _OSC code.
>      ACPI: Add platform-wide _OSC support.

it seems these three patches broke the _OSC on my intel new systems.

revert them fix the problem with AER and pciehp and etc

YH

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZHMTwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZHMTwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbZHMTwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:52:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:20527 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbZHMTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FDsXrfiEcgP7ztGFNqUhQ0/GfwdXLAxDNIYvtwO5R4gP0dnfDVcShlvni25x8nuXeS
         qzt5k0IZLdEGZpN+xF81IQYeVp5DK6f3fYgma5yjf2x7Tqm4tLtjbeEVpD3mRMkqxkzl
         vS2r9tmrfrecxST4jUa15wTV5YjXaiPwuva+s=
Message-ID: <4A846F04.9050005@gmail.com>
Date: Thu, 13 Aug 2009 21:52:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Brown, Len" <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: hibernate causes nobody cared on acpi irq
References: <4A833CAD.5050209@gmail.com> <200908130021.34378.rjw@sisk.pl>
In-Reply-To: <200908130021.34378.rjw@sisk.pl>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 12:21 AM, Rafael J. Wysocki wrote:
> On Thursday 13 August 2009, Jiri Slaby wrote:
>> with current mmotm I get this while trying to hibernate from a system in
>> qemu:
> 
> Does it trigger with the "core" test:

Yes, but I found out it's totally unrelated to the susp code. There is
an interrupt storm on IRQ9 after system boot -- 150000 intrs on both
CPUs in the first minute. Then the message emerges.

It's just a coincidence it appears during hibernation (after interrupts
enable phase).

Any idea what it could be?

Thanks.

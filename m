Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZCEWGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZCEWGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZCEWF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:05:56 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:37355 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZCEWFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:05:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IIA091fkgq3jxHkFsKcTVy6c07Xp2tjJb8IJ76C3t/Jf34UL8BtSk+++PtlwWrgb9Z
         zUeMaacH+KIeYOoPWa86UNg6dPvSBTE8bzy7Vht1pX0yruGb8rtwEVsqpTytSxQMzqG/
         d/Is7yhv052K5X8f40mQ6O7eSrkppjg0Z83cg=
Message-ID: <49B04CBE.9080308@gmail.com>
Date: Thu, 05 Mar 2009 23:05:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: clean up use of system_state in virt_addr_valid
 and co
References: <49AF35B0.2000302@goop.org>
In-Reply-To: <49AF35B0.2000302@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.3.2009 03:15, Jeremy Fitzhardinge wrote:
> x86-32: use specific __vmalloc_start_set flag in __virt_addr_valid
> x86-64: pre-initialize boot_cpu_data.x86_phys_bits to avoid system_state
> tests

Looks good, thanks. Just an idea, wouldn't make sense to add the check 
directly into is_vmalloc_addr?

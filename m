Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZHFPcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZHFPcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbZHFPcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:32:18 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:40021 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbZHFPcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:32:17 -0400
Message-ID: <4A7AF77C.3070204@pardus.org.tr>
Date: Thu, 06 Aug 2009 18:32:12 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] markup_oops: Use modinfo to avoid confusion with underscored
 module names
References: <1249561315-2227-1-git-send-email-ozan@pardus.org.tr> <20090806071129.3e5603ef@infradead.org>
In-Reply-To: <20090806071129.3e5603ef@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu,  6 Aug 2009 15:21:55 +0300
> Ozan Çağlayan <ozan@pardus.org.tr> wrote:
>
>   
>> When EIP is at a module having an underscore in its name, the current
>> code fails to find it because the module filenames has '-' instead of
>> '_'.
>>
>> Use modinfo to correctly get the full path to the module.
>>
>> Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
>>     
>
> I like it, it's simple.
> I don't mind about the module-init-tools dependency, everyone will have
> that already.
>   

BTW, note that the old code was searching for *.ko files in
dirname($vmlinux_name). Replacing it by modprobe will eventually always
search for the modules in /lib/modules/KVER/.

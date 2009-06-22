Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZFVJk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZFVJk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZFVJkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:40:20 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:59749 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZFVJkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nQNHVkPz7ogXoEi2MQ6evrmt8J94jFyW24+7er/VkMeXmkoKK7zdcT/7EggGYRb2DX
         6HFoCDxHTWNTdDwd7YijcN0ofp9VpFMow2Ux6m3nmFICcHgZYfXpf9/BLSvcKu4J6ONe
         jlQ7usRpb0urLuETyohNixFk+M3fZG6HxGDcc=
MIME-Version: 1.0
In-Reply-To: <4A3E7F38.7030300@linux.intel.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3E7F38.7030300@linux.intel.com>
Date: Mon, 22 Jun 2009 11:40:19 +0200
Message-ID: <8db1092f0906220240h5f20a3e8y173fa4d58c56d29c@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, seto.hidetoshi@jp.fujitsu.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/21 Andi Kleen <ak@linux.intel.com>:

> Does it still happen with CONFIG_X86_OLD_MCE instead?

Works without any problem:
maciek@zlom:~$ cat /boot/config-2.6.30-git17 | grep -i mce
CONFIG_X86_MCE=y
CONFIG_X86_OLD_MCE=y
CONFIG_X86_ANCIENT_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_X86_MCE_P4THERMAL is not set

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl

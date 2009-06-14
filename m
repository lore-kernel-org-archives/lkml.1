Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZFNQJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZFNQJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 12:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbZFNQJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 12:09:15 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:65367 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbZFNQI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dSsvN7N73KUkTCkz0TzBsh8wlyrskD17/WlH/rg4IunQVcEUeWVAOCejwAhN1BJket
         1KR9OSk9m8h9dnpZBRn+a+dvSrrgi1eH53W35jfKtatdf+z9jjapZYnamEBjG0kM6Mp5
         DLMPdNss0gSb2edOV+bKdAuqAi8QXfG1xUoHs=
Message-ID: <4A351FB0.3060008@gmail.com>
Date: Sun, 14 Jun 2009 18:05:04 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Arnd Bergmann <arnd@arndb.de>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 04/14] Pramfs: Mounting as root filesystem
References: <4A33A7D7.3040008@gmail.com> <200906140104.43463.arnd@arndb.de>	 <4A34B2FD.20701@gmail.com> <1244970445.3468.2732.camel@macbook.infradead.org>
In-Reply-To: <1244970445.3468.2732.camel@macbook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Sun, 2009-06-14 at 10:21 +0200, Marco wrote:
>> Mmm...MEM_MAJOR and RAMDISK_MAJOR have the same value and pramfs works
>> in memory. We could simply use /dev/null (there was an error in the
>> submitted kconfig description, my intention was to use /dev/mem). In
>> that case I can use UNNAMED_MAJOR. PRAMFS root option is not enabled
>> if it's already enabled the NFS one. What do you think?
> 
> Why use a major number at all? See how we handle mtd and ubi devices in
> prepare_namespace() -- can't you do something similar?
> 

I can look at it.

Marco

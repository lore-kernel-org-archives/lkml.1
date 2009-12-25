Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbZLYDsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbZLYDsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 22:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZLYDsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 22:48:37 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:41708 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZLYDsh (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 22:48:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=VEVog/6VTxvjqfz4krdJhKr/E9V3YqcqRifaXt8JUWvdfRW9tTyXQWA3LRflbbrw/v
         S75p0BT9QhZWW+GNYEgIqZIYGBLl228ho1HN2SQcnjPM1mp56p/0zDovlXhiXgQ5Fs/d
         9o4yYKamHEXnunw8Yh5SyTRJCdnHUCFQhsoWM=
Message-ID: <4B343611.6070206@gmail.com>
Date: Thu, 24 Dec 2009 19:48:33 -0800
From: JD <jd1008@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel List <Linux-Kernel@vger.kernel.org>
Subject: RT2860 driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have built and booted several kernel.org releases of
kernel 2.6, ever since rt2860 was added to the staging area.
I have an rt2860 mini-pci wifi card.
To make a long story short, the last kernel release I built
with rt2860 config enabled (module), that actually worked
(i.e. rt2860 driver worked) was (I think) kernel 2.6.28.

I have not been able to get it working in 2.6.[29,30,31,32]

So, what I have been doing is to copy full rt2860 directory
(which I had extracted and saved from the last working version)
into the latest kernel, and I make sure that

rt2860/config.mk has

HAS_WPA_SUPPLICANT=y

HAS_NATIVE_WPA_SUPPLICANT_SUPPORT=y

This is the only way I can get my wireless working.

So, if anyone on this list has it working in latest kernel,
without resorting to what I am doing, please share you "how-to".

If this is the wrong list to ask about this, then please tell,
which list discusses driver problems?

Cheers,

JD



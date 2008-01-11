Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbYAKQW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbYAKQW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759821AbYAKQWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:22:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbYAKQWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:22:50 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: The ext3 way of journalling
To: Matthias Schniedermeyer <ms@citd.de>, Tuomo Valkonen <tuomov@iki.fi>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 11 Jan 2008 17:22:45 +0100
References: <9JpbI-5yi-9@gated-at.bofh.it> <9Jqri-7ym-17@gated-at.bofh.it> <9JqUn-8bF-15@gated-at.bofh.it> <9JvKj-85h-41@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JDMeb-0003qH-Mv@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/VsepbgRq851mYAmGBYGUCSordLfxlECHvWvs
 her61Vs/olcwAIyA5z8Pl+ehEPQKvB7zSfSUaryaOhx6H2EEF6
 wYQ5q3iwBImHSMiJLMJjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schniedermeyer <ms@citd.de> wrote:

>> > Don't use udev then. Good old static dev works fine if you have a fixed
>> > set of devices.
>> 
>> It doesn't, with the unpredictable SCSI mapping insanity.
> 
> That what LABEL und UUID-Support in mount is for.
> 
> You label the filesystems (e2label for ext2 and ext3) and use that label to
> mount them
> 
> - fstab -
> LABEL=root  /        xfs     defaults,noatime 0 1
> LABEL=boot  /boot    ext2    defaults,noatime 0 2

What can happen if someone does tune2fs -Lroot /dev/usbstick
and puts that stick into this system?


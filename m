Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYHUSjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYHUSjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYHUSja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:39:30 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:57426 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYHUSj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E1XUvQ/PU3XiHc+3cAO088EcagYWFHPyBnxG9jsjFbqlauXv3MZ9Zu5Lio1eStvIYc
         J39VwwXH4SXB3Zbez5mYzMa+PckvqzoV/VR15KBuIH55rxfmBaNynmwwW8LwLUIyi6Kt
         qMwuQ/SRqg6+u81G6mqYtNKX/yZ6ClYQYYY24=
Message-ID: <19f34abd0808211139s24f0d57bq7fbd6d2963594919@mail.gmail.com>
Date: Thu, 21 Aug 2008 20:39:28 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808211131h7c4b4fcfo99f858218aad8027@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
	 <200808212022.18598.rjw@sisk.pl>
	 <19f34abd0808211131h7c4b4fcfo99f858218aad8027@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 8:31 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Thu, Aug 21, 2008 at 8:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Thursday, 21 of August 2008, Vegard Nossum wrote:
>>>
>>> I just got this on v2.6.27-rc4 (+ unrelated fix):
>>>
>>> ACPI: Preparing to enter system sleep state S5
>>
>> This looks fishy.
>>
>> Please check what's there in /sys/power/disk .
>>

Sorry, forgot this one:

# cat /sys/power/disk
test testproc [shutdown] reboot


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

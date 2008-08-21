Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYHUSb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYHUSb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYHUSbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:31:48 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:53305 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbYHUSbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=K0XkNgCd07IY3ajjf6yJ4hMRrs+g8wqfQDc3wD05oFrdh10QCJSDlx3y/eKFns7jEn
         Q5qKgSxLiSQOmsCzKladt6JwnEcWCkc8EH6I1w2eMrfKWgDNH2KLy1iqjV4KBwJ9Omh7
         7fFxlfMzWfk0Cxl4BMo+TzkOL8rofHcwgnCJ8=
Message-ID: <19f34abd0808211131h7c4b4fcfo99f858218aad8027@mail.gmail.com>
Date: Thu, 21 Aug 2008 20:31:46 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200808212022.18598.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
	 <200808212022.18598.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 8:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, 21 of August 2008, Vegard Nossum wrote:
>> Hi,
>>
>> I just got this on v2.6.27-rc4 (+ unrelated fix):
>>
>> ACPI: Preparing to enter system sleep state S5
>
> This looks fishy.
>
> Please check what's there in /sys/power/disk .
>
> Also, can you please post the full dmesg containing those traces?

Yep, here is:

http://userweb.kernel.org/~vegard/bugs/20080821-acpi/dmesg.txt

There seems to be a few different ACPI errors scattered throughout the log.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZKDORQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZKDORQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbZKDORQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:17:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbZKDORP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:17:15 -0500
Message-ID: <4AF18CD9.40201@redhat.com>
Date: Wed, 04 Nov 2009 09:16:57 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: Rajat Jain <Rajat.Jain@infogain.com>, loody <miloody@gmail.com>,
       linux-kernel@vger.kernel.org,
       Kernel Newbies <kernelnewbies@nl.linux.org>
Subject: Re: why kernel implement "udelay" by cpu instructions?
References: <3a665c760911011913q268b010cqb5da4f79df995b9b@mail.gmail.com> 	<4AEE63E2.9010003@redhat.com> <3a665c760911031819t2fef1720q3e2f542a2e56a3d0@mail.gmail.com> 	<C86899CCB10A6C4E93D5978DCB232D4B0D754B62@GDCMX01.igglobal.com> <3e8340490911032136x56696cc3u3b6f3b1e5d132324@mail.gmail.com>
In-Reply-To: <3e8340490911032136x56696cc3u3b6f3b1e5d132324@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2009 12:36 AM, Bryan Donlan wrote:

> I thought hrtimers allow higher-precision wakeups these days?
> Of course, if you only want to sleep for a few microseconds, the
> context switch might take longer than you want to sleep...

Also, you may not be in a context where you can schedule.

Sometimes drivers need to implement a small delay (to wait
for something on the device) while holding a spinlock or
while interrupts are disabled.

-- 
All rights reversed.

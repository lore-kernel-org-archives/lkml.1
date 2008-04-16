Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbYDPJ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbYDPJ72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 05:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbYDPJ7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 05:59:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:57251 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbYDPJ7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 05:59:17 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
To: Anton Altaparmakov <aia21@cam.ac.uk>,
       Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Miklos Szeredi <miklos@szeredi.hu>, dwmw2@infradead.org,
       hch@infradead.org, me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 16 Apr 2008 11:56:43 +0200
References: <aiwLk-3mc-3@gated-at.bofh.it> <aiwLk-3mc-5@gated-at.bofh.it> <aiwLk-3mc-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Jm4Ng-0000su-2j@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19sbveyvWI4uSQb4fA2f191xKC4oDHKt95Bnyp
 R/3nDC0F4w38ZEPGZAnB0vr6LLAebsYLsruXHZoa4df09XER/H
 bYNRrkuBAZimb5Q78tPSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Altaparmakov <aia21@cam.ac.uk> wrote:
> On 14 Apr 2008, at 13:46, Szabolcs Szakacsits wrote:
>> On Mon, 14 Apr 2008 Anton Altaparmakov wrote:

>>> (and under no-one I include the OOM killer for example!)
>>
>> The OOM killer can be configured and if the fs still uses too much
>> memory
>> then probably it's better to be killed/restarted with journaling
>> support.
>> The important here would be the kernel finally fixing the non-sync
>> behavior
>> when it clams to do so (see recent kernel threads).
> 
> You don't get the point.  Any process in the system can be using too
> much memory and trigger the OOM killer even when the FS is behaving
> just fine...

Just set /proc/$pid/oom_adj to -17.


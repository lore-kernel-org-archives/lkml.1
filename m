Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbYCVW7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbYCVW7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbYCVW7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:59:36 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:37911 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYCVW7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:59:35 -0400
Date: Sat, 22 Mar 2008 23:59:33 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.org
Subject: Re: 2.6.25-rc6: kernel BUG at fs/sysfs/file.c:89
In-Reply-To: <20080322150848.bf165996.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.00.0803222357370.6948@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803212319130.17137@sheep.housecafe.de> <200803220226.35552.rjw@sisk.pl> <20080321222606.16407d74.akpm@linux-foundation.org> <alpine.DEB.1.00.0803221942050.4470@sheep.housecafe.de> <alpine.DEB.1.00.0803222128570.6948@sheep.housecafe.de>
 <20080322150848.bf165996.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Andrew Morton wrote:
>> Hm, this was strange: I applied Neil's patch (and the dm-crypt patch) on
>> 2.6.25-rc6 and I kept getting SCSI errors (and lockups) when doing "tar
>> -cf - | dd of=/dev/null" - which I did to generate disk I/O.
>
> Please send all the details about this, retaining all cc's.

Hm, reproducing seems easy, but as nothings get written to disk or to the 
remote syslog server anymore, I don't have any error messages - yet.

C.
-- 
BOFH excuse #93:

Feature not yet implemented

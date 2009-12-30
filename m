Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZL3Q6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZL3Q6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbZL3Q6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:58:14 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:51678 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZL3Q6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:58:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rlZR0iBfE4rMe5H3UPQlOPdQYgCM1KXzWbNa8wYdDwDOIXlV2/+ocoX+uhEkIh01pQ
         JgSVTTaJq+30//2hu+bAfp0DE0eqacS5eaLaLEOGCeLrQv5M+dog9Z4CKGRGp1CjYd/6
         0d07GnuW3pakKCEX3+ht3BG9UugQJZsf0yC/s=
Message-ID: <4B3B869F.8090003@lwfinger.net>
Date: Wed, 30 Dec 2009 10:58:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.33-rc2: Reported regressions 2.6.31 -> 2.6.32
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2009 09:26 AM, Rafael J. Wysocki wrote:
> [NOTES:
>  * I really hope that at least _some_ of the bugs below have been already
>    fixed, but I didn't have the time to search through all of the histories.
>    _Please_ let me know which of them can be closed.
>  * If you close one of the bugs in this list, please do your best to put the
>    hash of the fix commit into the Bugzilla entry.]
> 
> This message contains a list of some regressions introduced between 2.6.31 and
> 2.6.32, for which there are no fixes in the mainline I know of.  If any of them
> have been fixed already, please let me know.


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14743
> Subject		: New rtl8187 rfkill support prevents using wlan completely.
> Submitter	: Antti Kaijanmäki <antti@kaijanmaki.net>
> Date		: 2009-12-05 20:10 (25 days old)


This bug is fixed in mainline with commit
70d57139f932b9ca21026253d02af71cf53d764a. This patch has also been backported to
2.6.32.2. The status of the Bugzilla entry has been changed to "CLOSED with CODE
FIX".

Larry

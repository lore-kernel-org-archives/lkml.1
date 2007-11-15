Return-Path: <linux-kernel-owner+w=401wt.eu-S933762AbXKOX74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbXKOX74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbXKOX7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:59:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:57216 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbXKOX7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:59:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Gd+7S6PPrzTbwMhz9xlMWCxGWOlBXLNbq+3JjgAMo8yww4kxiHbhQ++OZfaJLlcopXwaADW9C0GyaVPAq1VFz/kvWpStRO4DVqWHnTg3ktklQE+sDm0RNkTZDz9vhRCwUGNCX7KTKTuviTqZgBOSrkgpuqeTmoFiU7ZFAiyvSrM=
Message-ID: <473CDD6D.8080008@gmail.com>
Date: Fri, 16 Nov 2007 00:59:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <473B5987.60904@gmail.com> <200711142248.59547.rjw@sisk.pl>
In-Reply-To: <200711142248.59547.rjw@sisk.pl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2007 10:48 PM, Rafael J. Wysocki wrote:
> On Wednesday, 14 of November 2007, Jiri Slaby wrote:
>> On 11/14/2007 02:59 AM, Andrew Morton wrote:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/
>> Doesn't suspend for me (neither broken-out-2007-11-13-04-14 did) on x86_64.
>> echo mem >/sys/power/state
>> causes shut down of disk(s) and blinking cursor on 1,1 position.
>> The last working was 2.6.23-rc8-mm2. I haven't tested
>> 2.6.23-mm1, since it didn't work for me.
> 
> Does the current mainline work?

Yes.

The offending -mm patch is
gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch

2.6.24-rc2-mm1 minus it works just fine; PROVE_LOCKING shows nothing new when
the patch is applied.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University


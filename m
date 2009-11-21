Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbZKURha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbZKURha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 12:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbZKURh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 12:37:29 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33493 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbZKURh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 12:37:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yBF4zu5LemfTik1ISwXlSepUtBbiJX2sJb1WShjwGC4w+xJg3MNAVXyfPYBq/QkTUA
         qLq3wzfAMkbJHwwjWa6RRDRcbQzOgJ9XJM7N9nEQzzhP4RfQkx7EIIQDf1WYa7svdGeY
         2TQJjY4vTClqUX/O2CsmJLYAjZr7RlgtoBQVQ=
Message-ID: <4B08258E.9050607@gmail.com>
Date: Sat, 21 Nov 2009 09:38:22 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera> <mYW9sxtWd2G.A.EnF.gDACLB@chimera>
In-Reply-To: <mYW9sxtWd2G.A.EnF.gDACLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
> Subject		: Disassociating atheros wlan
> Submitter	: Kristoffer Ericson<kristoffer.ericson@gmail.com>
> Date		: 2009-09-24 10:16 (59 days old)
> References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4
>
>
>
>    
I did a bisect yesterday on this, and the results
seemed to have worked over here by reverting:

75e6c3b72b3ab01c47629f3fbd0fed4e6550bf3a
cfg80211: lower dynamic PS timeout to 100ms

if Kristoffer can try reverting this one
to see, then we can go from there.

Justin P. Mattock




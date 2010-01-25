Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569Ab0AYT2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0AYT2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625Ab0AYT2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:28:00 -0500
Received: from ns01.unsolicited.net ([69.10.132.115]:3986 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0AYT2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:28:00 -0500
Message-ID: <4B5DF061.1070704@unsolicited.net>
Date: Mon, 25 Jan 2010 19:26:25 +0000
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14924] Weird hard hangs when rendering 'some' web-sites
 in Firefox
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.V3G.JLMXLB@chimera> <20100125135531.GB3749@hack>
In-Reply-To: <20100125135531.GB3749@hack>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Sun, Jan 24, 2010 at 11:04:33PM +0100, Rafael J. Wysocki wrote:
>   
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>>     
> >from 2.6.32.  Please verify if it still should be listed and let me know
>   
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14924
>> Subject		: Weird hard hangs when rendering 'some' web-sites in Firefox
>> Submitter	: David <david@unsolicited.net>
>> Date		: 2009-12-21 21:53 (35 days old)
>> References	: http://marc.info/?l=linux-kernel&m=126143375823340&w=4
>>     
>
> Hmm, you have CONFIG_DETECT_SOFTLOCKUP=y, I have no idea what happened,
> doing a bisect would be appreciated.
>
> Thanks.
>
>   

I no longer have the offending hardware, but I think that the issue was
probably corrected by:

    cafe6609d6dc0a6a278f9fdbb59ce4d761a35ddd -
drm/radeon/kms: Schedule host path read cache flush through the ring V2

as the offending ATI graphics was indeed R300.

Cheers
David



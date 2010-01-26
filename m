Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652Ab0AZDG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab0AZDG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550Ab0AZDG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:06:56 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:52171 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab0AZDGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:06:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pArXkU58GdZEh8gTijq6u+YzRa+FB8VVjmA5GZrsQYwtB2hlV/UxwGFJtMytBBlHwt
         fauy1a7tQDXygNQObFPcqCs3yBqiAUrF1RaaM4AV2jnO2PrqOwQzi7hAofkSbug34JJt
         asf9b9mV9y4rEVTPNOA1sLA0UqZtU1ymJizYo=
MIME-Version: 1.0
In-Reply-To: <4B5DF061.1070704@unsolicited.net>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	 <hE3x9c-4KZM.A.V3G.JLMXLB@chimera> <20100125135531.GB3749@hack>
	 <4B5DF061.1070704@unsolicited.net>
Date: Tue, 26 Jan 2010 11:06:53 +0800
Message-ID: <2375c9f91001251906s520112ebuf12f60729b004857@mail.gmail.com>
Subject: Re: [Bug #14924] Weird hard hangs when rendering 'some' web-sites in 
	Firefox
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: David <david@unsolicited.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 3:26 AM, David <david@unsolicited.net> wrote:
> Américo Wang wrote:
>> On Sun, Jan 24, 2010 at 11:04:33PM +0100, Rafael J. Wysocki wrote:
>>
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>>
>> >from 2.6.32.  Please verify if it still should be listed and let me know
>>
>>> (either way).
>>>
>>>
>>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=14924
>>> Subject              : Weird hard hangs when rendering 'some' web-sites in Firefox
>>> Submitter    : David <david@unsolicited.net>
>>> Date         : 2009-12-21 21:53 (35 days old)
>>> References   : http://marc.info/?l=linux-kernel&m=126143375823340&w=4
>>>
>>
>> Hmm, you have CONFIG_DETECT_SOFTLOCKUP=y, I have no idea what happened,
>> doing a bisect would be appreciated.
>>
>> Thanks.
>>
>>
>
> I no longer have the offending hardware, but I think that the issue was
> probably corrected by:
>
>    cafe6609d6dc0a6a278f9fdbb59ce4d761a35ddd -
> drm/radeon/kms: Schedule host path read cache flush through the ring V2
>
> as the offending ATI graphics was indeed R300.
>

Ok, thanks!

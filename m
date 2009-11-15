Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbZKOWOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbZKOWOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZKOWOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:14:35 -0500
Received: from mail.lang.hm ([64.81.33.126]:48438 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbZKOWOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:14:34 -0500
Date: Sun, 15 Nov 2009 14:14:34 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       John Johansen <john.johansen@canonical.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 07/12] AppArmor: userspace interfaces
In-Reply-To: <20091110102116.2bc5bc4f@nehalam>
Message-ID: <alpine.DEB.2.00.0911151414020.6163@asgard.lang.hm>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com> <1257869585-7092-8-git-send-email-john.johansen@canonical.com> <84144f020911100829k515c7f73w84df942162a49a30@mail.gmail.com> <87pr7qjpn8.fsf@basil.nowhere.org>
 <20091110102116.2bc5bc4f@nehalam>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-558440052-1258323274=:6163"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-558440052-1258323274=:6163
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 10 Nov 2009, Stephen Hemminger wrote:

> On Tue, 10 Nov 2009 17:44:27 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
>
>> Pekka Enberg <penberg@cs.helsinki.fi> writes:
>>
>>> On Tue, Nov 10, 2009 at 6:13 PM, John Johansen
>>> <john.johansen@canonical.com> wrote:
>>>> The current apparmorfs interface is compatible with previous versions
>>>> of AppArmor.  The plans are to deprecate it (hence the config option
>>>> APPARMOR_COMPAT_24) and replace it with a more sysfs style single
>>>> entry per file interface.
>>>
>>> We don't usually merge compatibility code to handle ABIs that were
>>> developed out-of-tree. Why should we treat AppArmor differently?
>>
>> I would say that always depends on the deployed base of the old ABI.
>> If there's a lot of users who would get broken I think there's a
>> good case for merging compat code (I don't know if that is or
>> isn't the case here).
>>
>> A widely used distribution release with the old user land would
>> probably count.
>>
>
> Then the distribution can maintain a patch to add the necessary translation

that works for future releases, but not for past releases.

David Lang

> It is not the upstream kernel's job to maintain compatibility with older
> out of tree code.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
--680960-558440052-1258323274=:6163--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbZKOWOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbZKOWOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZKOWOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:14:09 -0500
Received: from mail.lang.hm ([64.81.33.126]:48433 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZKOWOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:14:09 -0500
Date: Sun, 15 Nov 2009 14:13:56 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Andi Kleen <andi@firstfloor.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       John Johansen <john.johansen@canonical.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 07/12] AppArmor: userspace interfaces
In-Reply-To: <87pr7qjpn8.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.00.0911151413280.6163@asgard.lang.hm>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com> <1257869585-7092-8-git-send-email-john.johansen@canonical.com> <84144f020911100829k515c7f73w84df942162a49a30@mail.gmail.com> <87pr7qjpn8.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-658448519-1258323240=:6163"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-658448519-1258323240=:6163
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 10 Nov 2009, Andi Kleen wrote:

> Pekka Enberg <penberg@cs.helsinki.fi> writes:
>
>> On Tue, Nov 10, 2009 at 6:13 PM, John Johansen
>> <john.johansen@canonical.com> wrote:
>>> The current apparmorfs interface is compatible with previous versions
>>> of AppArmor.  The plans are to deprecate it (hence the config option
>>> APPARMOR_COMPAT_24) and replace it with a more sysfs style single
>>> entry per file interface.
>>
>> We don't usually merge compatibility code to handle ABIs that were
>> developed out-of-tree. Why should we treat AppArmor differently?
>
> I would say that always depends on the deployed base of the old ABI.
> If there's a lot of users who would get broken I think there's a
> good case for merging compat code (I don't know if that is or
> isn't the case here).
>
> A widely used distribution release with the old user land would
> probably count.

ubuntu has shipped with AppArmor for the last few releases.

David Lang
--680960-658448519-1258323240=:6163--

Return-Path: <linux-kernel-owner+w=401wt.eu-S932318Ab0A1UVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab0A1UVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283Ab0A1UVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:21:16 -0500
Received: from mail-iw0-f172.google.com ([209.85.223.172]:63620 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab0A1UVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:21:14 -0500
MIME-Version: 1.0
X-Originating-IP: [66.187.234.200]
In-Reply-To: <2375c9f91001261834l1e267a8bp61633f63b3752f6f@mail.gmail.com>
References: <20100126222041.GR4472@redhat.com>
	 <2375c9f91001261834l1e267a8bp61633f63b3752f6f@mail.gmail.com>
Date: Thu, 28 Jan 2010 15:21:13 -0500
Message-ID: <be3a4a1001281221m47d5fae8v55aa18b7de1aedff@mail.gmail.com>
Subject: Re: [scripts] python: change scripts to use system python instead of 
	env
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 9:34 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Jan 27, 2010 at 6:20 AM, Don Zickus <dzickus@redhat.com> wrote:
>> Doh. Typo in the To: field
>>
>> ----- Forwarded message from Don Zickus <dzickus@redhat.com> -----
>>
>> Date: Fri, 22 Jan 2010 16:32:10 -0500
>> From: Don Zickus <dzickus@redhat.com>
>> To: lkml@vger.kernel.org
>> Cc: akpm@linux-foundation.org, tglx@linutronix.de, tony.luck@intel.com,
>>        kmcmartin@redhat.com, Don Zickus <dzickus@redhat.com>
>> Subject: [scripts] python: change scripts to use system python instead of env
>> Message-Id: <1264195930-15815-1-git-send-email-dzickus@redhat.com>
>>
>> Just a small change to a couple of scripts to go from
>>
>>  #!/usr/bin/env python
>>
>> to
>>
>>  #!/usr/bin/python
>>
>> This shouldn't effect anyone, unless they don't install python there.
>>
>> In preparation for python3, Fedora is doing a big push to change the scripts
>> to use the system python.  This allows developers to put the python3 in
>> their path without fear of breaking existing scripts.
>>
>> Now I am pretty sure anyone using python3 for testing purposes will probably
>> not run any of the scripts I changed, but Fedora has this automated tool
>> that checks for this stuff so I thought I would try to push it upstream.
>
>
> Hmm, so python3 will be installed in /usr/local/bin?

No, it will be /usr/bin/python3, but its possible a user would
configure their environment to have their default python interpreter
be python3, in which case env python would be using /usr/bin/python3
rather than /usr/bin/python, which can lead to things mysteriously
running differently or not running at all.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com

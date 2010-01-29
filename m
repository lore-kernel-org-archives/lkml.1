Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569Ab0A2Lu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0A2Lu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 06:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932176Ab0A2Lu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 06:50:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab0A2Lu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 06:50:56 -0500
Message-ID: <4B62CBA1.3060001@suse.cz>
Date: Fri, 29 Jan 2010 12:50:57 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [scripts] python: change scripts to use system python instead
 of  env
References: <20100126222041.GR4472@redhat.com>	 <2375c9f91001261834l1e267a8bp61633f63b3752f6f@mail.gmail.com> <be3a4a1001281221m47d5fae8v55aa18b7de1aedff@mail.gmail.com>
In-Reply-To: <be3a4a1001281221m47d5fae8v55aa18b7de1aedff@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson napsal(a):
> On Tue, Jan 26, 2010 at 9:34 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Wed, Jan 27, 2010 at 6:20 AM, Don Zickus <dzickus@redhat.com> wrote:
>>> Just a small change to a couple of scripts to go from
>>>
>>>  #!/usr/bin/env python
>>>
>>> to
>>>
>>>  #!/usr/bin/python
...
>>
>> Hmm, so python3 will be installed in /usr/local/bin?
> 
> No, it will be /usr/bin/python3, but its possible a user would
> configure their environment to have their default python interpreter
> be python3, in which case env python would be using /usr/bin/python3
> rather than /usr/bin/python, which can lead to things mysteriously
> running differently or not running at all.
> 
> Acked-by: Jarod Wilson <jarod@redhat.com>

OK, and we have other python scripts that already use #!/usr/bin/python,
so this patch makes sense regardless of python3. I added it to the
kbuild tree.

Michal

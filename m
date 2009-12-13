Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZLMVwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZLMVwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZLMVwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:52:05 -0500
Received: from 216-239-44-51.google.com ([216.239.44.51]:14057 "HELO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754379AbZLMVwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:52:00 -0500
X-Greylist: delayed 820 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Dec 2009 16:52:00 EST
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=jbzbF3nYEmRG9x8ZMqojLrxOCd8adc+nnhdGMqZ7byZCrgG3Er18XWmPEFdbbbjGA
	pugGxYrtyARcBTTCNs+cQ==
MIME-Version: 1.0
In-Reply-To: <20091213212918.GE5114@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
	 <20091208224550.GA26915@n2100.arm.linux.org.uk>
	 <d6200be20912081639mdd853bg4080f415116d018c@mail.gmail.com>
	 <20091209113739.GC22752@elf.ucw.cz>
	 <1260375495.23633.175.camel@desktop>
	 <20091213212918.GE5114@elf.ucw.cz>
Date: Sun, 13 Dec 2009 13:38:16 -0800
Message-ID: <a55d774e0912131338x6d44b5c9s5655c549ac594815@mail.gmail.com>
Subject: Re: GPIO support for HTC Dream
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 1:29 PM, Pavel Machek <pavel@ucw.cz> wrote:
>>
>> I'm going to end up pulling a lot of these git commit into my git tree.
>> It would be pretty easy for me to just pull this GPIO change directly ..
>> I assume you haven't found a way to work with git that suites you? It
>> would be best if you used git, but I could try to do some sort of quilt
>> export if that works better for you.
>
> I can easily "pull" git trees. I do my own work in git, but usually
> not in a way that would be useful for pushing upstream (see my trees
> at git.kernel.org).
>
> I *could* add my dream trees to those that are mirrored at kernel.org,
> when things settle a bit. (Should I?)
>
> But I'd really prefer to push my stuff using plain old patches in
> emails.

It would probably be helpful for those of us at Google and Qualcomm,
who have an entirely git-based workflow to be able to pull patches
from somewhere, especially if you already have trees that you could
publish and it's not a huge burden on you.

What has worked well for me the last couple times I've sent patches
out was to put them in an outgoing git branch somewhere, use the git
tools to email them to lkml/lakml for review, and include a pointer to
the git://... that people can pull from -- sorta the best of both
worlds.

Brian

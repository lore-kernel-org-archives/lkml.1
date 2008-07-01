Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYGAHy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYGAHy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYGAHyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:54:49 -0400
Received: from saeurebad.de ([85.214.36.134]:51269 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbYGAHys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:54:48 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 00/20] mm: generic show_mem() v4
References: <20080627115349.743368154@saeurebad.de>
	<8763rq6qlc.fsf@skyscraper.fehenstaub.lan>
	<20080701002518.7918fdaf.akpm@linux-foundation.org>
Date: Tue, 01 Jul 2008 09:54:11 +0200
In-Reply-To: <20080701002518.7918fdaf.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 1 Jul 2008 00:25:18 -0700")
Message-ID: <87iqvq59b0.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 01 Jul 2008 08:55:27 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> Hi,
>> 
>> Johannes Weiner <hannes@saeurebad.de> writes:
>> 
>> > Every arch implements its own show_mem() function.  Most of them share
>> > quite some code, some of them are completely identical.
>> >
>> > This series implements a generic version of this function and migrates
>> > almost all architectures to it.
>> >
>> > version 4:
>> > 	- rebased against -mmotm
>> 
>> Oh, btw, do you even want them, Andrew?
>
> These are only a few hundred patches ahead of my current backlog cursor
> :( I should be caught up mid-weekish.
>
>>  Or should I base this set on
>> Linus' tree directly?
>
> That would be a bad step.  Linus's tree is 2.6.26 whereas we're all
> developing 2.6.27.  There's a ~30MB diff between the two.

Alright, I will keep them against -mmotm and resend them soon without
the Kconfig stuff as suggested by Paul Mundt.

	Hannes

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbZLNXLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbZLNXLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758754AbZLNXLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:11:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758741AbZLNXLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:11:34 -0500
Message-ID: <4B26C68D.1080300@gmail.com>
Date: Tue, 15 Dec 2009 00:13:17 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Pavel Machek <pavel@ucw.cz>, Paul Mundt <lethal@linux-sh.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for 2.6.32-git-053fe57ac
 v2
References: <cover.1260662994.git.re.emese@gmail.com>	<20091214003836.GD7812@parisc-linux.org>	<4B2595E7.701@gmail.com>	<20091214021916.GB12196@linux-sh.org>	<4B25E47C.1010803@gmail.com>	<20091214112656.GB1959@elf.ucw.cz> <20091214080049.19930729@infradead.org>
In-Reply-To: <20091214080049.19930729@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Now, a 300 patch series to lkml is not the way to do this.
> First step is to make checkpatch.pl warn about new cases.

I will add this structures the checkpatch in the next patch series.

> Second step should be to convert all definitions, but using the "one
> patch per maintainer" rule, not "one patch per file" rule. Yes it's
> somewhat janitorial, but no it's not a big deal as long as it's not 300
> patches to lkml. And it is much better than whitespace changes; it's
> a real quality improvement to the kernel (in terms of code generation
> and API)

The first series was based on one patch per structure type, the current
split-up is based on one patch per structure type *and* subsystem as
suggested by Greg KH. I used get_maintainer --subsystem to find them which
resulted in 150 patches. If you know a better way or want per-type patches,
please let me know (and discuss it with Greg ;).
--
Emese



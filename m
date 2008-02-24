Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYBXRgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYBXRgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYBXRgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:36:32 -0500
Received: from khc.piap.pl ([195.187.100.11]:48524 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYBXRgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:36:32 -0500
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Tabs, spaces, indent and 80 character lines
References: <47C0BEE7.4040409@student.ltu.se>
	<m3ejb2bdxx.fsf@maximus.localdomain> <47C19001.7010609@student.ltu.se>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 24 Feb 2008 18:36:30 +0100
In-Reply-To: <47C19001.7010609@student.ltu.se> (Richard Knutsson's message of "Sun\, 24 Feb 2008 16\:40\:49 +0100")
Message-ID: <m3ablqb6jl.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Knutsson <ricknu-0@student.ltu.se> writes:

>> I guess we could use tabs only at the line start, for indentation
>> only. Rather hard to implement, most text editors can't do that yet.
>>   
> You mean for split lines?

Syntactic indentation vs alignment (including comments after
non-blank, values for struct initialization etc, split lines too).

> Hopefully there won't be that many, so there
> is just to delete the tabs it added and replace it with spaces.

Actually tabs "should" be used for indentation at start of the
line, then spaces. "Ideally" :-)

I.e., something like
<TAB>	if (cond && (cond2 ||
<TAB>	_____________cond3))
<TAB>	<TAB>	do_something();

Underline = space.

Perhaps some day...

> Exactly! But then we can remove the "we use 8 wide tabs in the kernel"
> in CodeStyle.

I'm not sure it's practically possible now.

>> Unpacked sources will be much bigger with not tabs, sure.
>>   
> Without no tabs at all, you mean?

With spaces in place of all tabs.

All tabs converted to spaces = 20% more?
"Alignment" tabs converted to spaces? How cares how much more would it
take if it's the correct thing. Except that it's not very practical at
this point.
-- 
Krzysztof Halasa

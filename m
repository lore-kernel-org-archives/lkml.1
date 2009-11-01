Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbZKAUj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbZKAUj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 15:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZKAUj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 15:39:27 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:56051 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZKAUj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 15:39:26 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: symlinks with permissions
Date: Sun, 1 Nov 2009 20:39:30 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hckrm2$6bl$1@taverner.cs.berkeley.edu>
References: <20091025062953.GC1391@ucw.cz> <4AEBB86F.3090601@schaufler-ca.com> <hcjk2m$v46$1@taverner.cs.berkeley.edu> <4AEDC8DD.4080806@schaufler-ca.com>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1257107970 6517 128.32.168.222 (1 Nov 2009 20:39:30 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 1 Nov 2009 20:39:30 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler  wrote:
>David Wagner wrote:
>> Pavel has provided a concrete attack script.  If you believe
>> that the protections afforded by that script can be circumvented,
>> how about showing us the specific attack, described to a similar
>> level of concreteness and specifity, that demonstrates how to
>> upgrade the read-only fd to a read-write fd without using /proc?
>>
>> Put another way: if you are right that the arguments about
>> pathname based access controls apply here and lead to the
>> conclusions you are espousing, then you should be able to
>> exhibit a specific, concrete, fully specified attack on Pavel's
>> script, without using /proc.  Right?
>
> No. The going in premise, that the behavior is a security flaw,
> is incorrect.  The mode bits on the file allow the requested access.

I see.  May I conclude that you are unable to answer my challenge?

I challenged you to show exactly how else a non-root user could gain write
access to the file, in Pavel's script, other than using /proc/../fd/...
Based on the fact that you have repeatedly declined to answer this
challenge, it sounds like I can safely conclude that you do not know of
any other way that a non-root user can accomplish this, in the situation
Pavel outlines.

So, it sounds like we have agreement that:

  * In the situation Pavel outlines, a malicious non-root user
    given read-only access to the file can use /proc/../fd/.. to
    upgrade that fd to read-write access.

  * If /proc/../fd/.. didn't exist, the non-root user would not have
    been able to do that.

So the /proc/../fd/.. mechanism is enabling a malicious user to get
access that they would not have been able to get in the absence of
this mechanism.

Do you agree with that summary?


The above are the facts, as I see them.  (In contrast, the following is
my opinion: It is my opinion that these facts demonstrate that this is
a security violation.)  But I'm not asking for your feedback about my
opinion; I'm asking you about the facts.  Do you agree with my statement
of the facts?

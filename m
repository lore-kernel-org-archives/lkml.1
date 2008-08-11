Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYHKWKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYHKWKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYHKWJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:09:56 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:46814 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYHKWJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:09:56 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Date: Mon, 11 Aug 2008 22:09:55 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <g7qdbj$6m0$2@taverner.cs.berkeley.edu>
References: <20080806105008.GF6477@cs181140183.pp.htv.fi> <20080811065608.44687f65@infradead.org> <48A0649B.4010706@sun.com> <2629CC4E1D22A64593B02C43E855530304AE4B80@USILMS12.ca.com>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1218492595 6848 128.32.168.222 (11 Aug 2008 22:09:55 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 11 Aug 2008 22:09:55 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Press, Jonathan wrote:
>I think everyone understands one side of the threat model, that is Linux
>machines being carriers of infections aimed at other platforms.  There
>are many ways that such infections can be stored, and many ways in which
>they can be communicated to the target machines.  There are so many that
>it would not be effective or efficient for each such transfer
>application to be able to handle its own malware scanning, which is the
>short statement of why centralized AV protection with notification
>assistance from the kernel is appropriate.

I'm not sure I follow.  Could you name a few channels that you think
are likely to represent a serious problem in practice (not just a
theoretical possibility)?  There are a few obvious ones: files shared
over a SMB filesystem; attachments sent via email.  What else?  Can
you give some other examples?

If it's true that there are an unbounded number of channels by which
malware could reach a target Windows machine, all of equal importance,
then it sounds to me like the end-to-end argument would suggest that the
virus scanner needs to be on the target machine.  (Otherwise there will
inevitably be some channel you missed.)  But I'm not convinced that this
is true.

One standard counter-argument to the end-to-end argument is that,
in some cases, we can identify a single chokepoint: a single central
machine or network where you can do virus scanning for a large collection
of machines, at much lower administrative cost.  If this addresses one
propagation channel that accounts for the overwhelming majority of
viral spread in practice, this can potentially be useful.  Is that the
idea you had in mind?

Are we talking about enterprise networks?  Are we talking about consumers?

I assume we're talking about a case where there is a Linux machine L
and a Windows machine W, and W is the target and there is a channel by
which malware can propagate from L to W, and L and W are under the same
administrative control (e.g., two machines owned by the same company).
Moreover, I'm assuming that L is secure and has not been compromised
(otherwise you've got a horse of a different color).  Have I understood
you correctly so far?

>It is true that most of our experience is with DOS and Windows, and that
>the types of attacks that can be launched there are not easy to
>generalize to other platforms.  However, that does not mean that
>non-Windows platforms like Linux are therefore immune, or that we are
>tilting at windmills to say that we address non-Windows infections. 
>There are many specific forms of malware on non-Windows platforms that
>we identify in the same way that we identify them on Windows.

The point is that you need to think about what classes of attacks you
want to defend against, and be able to precisely characterize which
attacks are and aren't in scope.  So far, I haven't seen any evidence
of that; I've just seen fuzzy slogans and hand-wavy "philosophies".

You can't stop them all, so pick your battles.

>In a sense the reason I have found the question about "threat model" to
>be so difficult to answer is that the basic unpredictability of the
>attack makes the answer in essence:  "Anything".  That is, it
>essentially doesn't matter what the threat is or how malware is
>implemented, except that we know that it exists, both in theory and in
>practice, and we have an effective way of detecting and removing it.

If your answer to the question of which security threats you want
to address is "All of them", then you've tackled a hopeless problem.
If that's your answer, give up now.  There is no silver bullet for
computer security.  You need to narrow your scope if you want to
have any hope of building something useful.

I dispute the claim that we have an effective way of detecting malware.
We have a way of detecting some malware.

I'm being blunt because I think sometimes it helps to hear it
told straight, without any sweetening.  Please forgive any impoliteness
this may cause.

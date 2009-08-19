Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbZHSJUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbZHSJUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZHSJUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:20:04 -0400
Received: from tim.des.no ([194.63.250.121]:61564 "EHLO tim.des.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbZHSJUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:20:03 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2009 05:20:03 EDT
From: =?utf-8?Q?Dag-Erling_Sm=C3=B8rgrav?= <des@des.no>
To: David Wagner <daw@cs.berkeley.edu>
Cc: rwatson@FreeBSD.org (Robert Watson), freebsd-hackers@FreeBSD.org,
       linux-kernel@vger.kernel.org, Oliver Pinter <oliver.pntr@gmail.com>
Subject: Re: Security: information leaks in /proc enable keystroke recovery
References: <200908162109.n7GL9JNK029605@taverner.cs.berkeley.edu>
Date: Wed, 19 Aug 2009 03:57:44 +0200
In-Reply-To: <200908162109.n7GL9JNK029605@taverner.cs.berkeley.edu> (David
	Wagner's message of "Sun, 16 Aug 2009 14:09:19 -0700 (PDT)")
Message-ID: <861vn85zvr.fsf@ds4.des.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (berkeley-unix)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner <daw@cs.berkeley.edu> writes:
> I agree we certainly shouldn't discuss the keystroke recovery attack
> as hypothetical, because it is clearly not hypothetical: the authors
> implemented it and found that it works.

It *is* hypothetical.  They were able to collect some keystrokes (but
not all) in Linux, but IIUC, all they could do in FreeBSD was figure out
whether or not a key was pressed at a certain time (or during a certain
interval).  They *hypothesize* that the interval between keystrokes can
be used to identify the keys being pressed, but they haven't actually
done it.  I can imagine - purely hypothetically - that it would be
possible, but only while the user was typing running text; the
parameters would vary greatly from typist to typist, and between
keyboard layouts, and you could probably defeat it pretty easily (at
least some of the time) by deliberately typing slowly and arythmically,
e.g. typing in your password with only one finger.

DES
-- 
Dag-Erling Smørgrav - des@des.no

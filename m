Return-Path: <linux-kernel-owner+w=401wt.eu-S1765513AbZAOTxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765513AbZAOTxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 14:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbZAOTx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 14:53:28 -0500
Received: from agrajag.mansr.com ([78.86.181.102]:47666 "EHLO mail.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbZAOTx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 14:53:27 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 14:53:27 EST
To: Jamie Lokier <jamie@shareable.org>
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
       =?iso-8859-1?Q?M?= =?iso-8859-1?Q?=E5ns_Rullg=E5rd?= 
	<mans@mansr.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net>
	<200901021026.37905.a.miskiewicz@gmail.com>
	<20090102094934.GB17841@infradead.org> <495DE995.1070002@opensde.org>
	<yw1x3ag2t2gd.fsf@thrashbarg.mansr.com>
	<496F3344.9060104@draigBrady.com>
	<20090115185224.GB5440@shareable.org>
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Date: Thu, 15 Jan 2009 19:45:10 +0000
In-Reply-To: <20090115185224.GB5440@shareable.org> (Jamie Lokier's message of "Thu, 15 Jan 2009 18:52:24 +0000")
Message-ID: <yw1xtz80z73t.fsf@thrashbarg.mansr.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.22 (Instant Classic, linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier <jamie@shareable.org> writes:

> Pádraig Brady wrote:
>> > The $(( ... )) construct is standard POSIX shell syntax, see
>> > http://www.opengroup.org/onlinepubs/000095399/utilities/xcu_chap02.html#tag_02_06_04
>> > 
>> > Bash supports $[ ... ] as an alternate syntax for the same thing.
>> > Perhaps you were thinking of that.
>> 
>> I think the misconception that $(( ... )) is a bashism is caused by
>> the wrong highlighting defaults chosen by vim.
>
> I think the misconception is because traditional unix bourne shells
> don't implement that construct.  I just tried it on a few machines,
> and it failed on 4 of them.  Admittedly, the only up to date one is
> running Solaris 10; the others are older unixes that you're unlikely
> to build Linux on.

On Solaris, /usr/xpg4/bin/sh is usually a POSIX-compliant shell.  I
don't know how long it has been there.

-- 
Måns Rullgård
mans@mansr.com

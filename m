Return-Path: <linux-kernel-owner+w=401wt.eu-S1766010AbYEBR1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766010AbYEBR1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764309AbYEBR10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:27:26 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:4635 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYEBR10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:27:26 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: "Parag Warudkar" <parag.warudkar@gmail.com>,
       "Adrian Bunk" <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to reduce the number of open kernel bugs
From: Andi Kleen <andi@firstfloor.org>
References: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com>
	<200805021229.47038.dhazelton@enter.net>
Date: Fri, 02 May 2008 19:27:04 +0200
In-Reply-To: <200805021229.47038.dhazelton@enter.net> (Daniel Hazelton's message of "Fri, 2 May 2008 12:29:46 -0400")
Message-ID: <87od7ovcpj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 17:20:09.0878 (UTC) FILETIME=[C60BE360:01C8AC78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton <dhazelton@enter.net> writes:
>  If the hardware works 
> perfectly in every other OS

It depends. There used to be the famous case (not longer true now) that 
older Linux allocated memory from the top of the memory down and other OS
generally allocated it the from bottom to up and when some of your top
memory was broken Linux would often hit problems where other OS did not.

Also there can be the case when some OS use hardware quite differently
or different hardware features than other. Standard case for example
used to be that there were a few platforms where the SMM code had 64bit
bugs and of course you would only hit them when running a 64bit OS which
was Linux. 

A modern OS is a very complicated system with tens of millions of code
lines and you can't assume they all program the hardware in the same way.

Simple truths are often wrong.

 - and possibly even previous versions of Linux - 

Now that is a more interesting case. But regressions are always taken
seriously by all maintainers I know.

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbXC1NSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbXC1NSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXC1NSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:18:08 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49545 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXC1NSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:18:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adrian Bunk <bunk@stusta.de>
Cc: Sid Boyce <g3vbv@blueyonder.co.uk>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45EFBC73.2030005@blueyonder.co.uk>
	<46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de>
	<m17itabbbv.fsf@ebiederm.dsl.xmission.com>
	<4601DCB4.4060804@blueyonder.co.uk>
	<20070321184258.758a5a29.randy.dunlap@oracle.com>
	<20070322105908.GS752@stusta.de> <4608919C.4050007@blueyonder.co.uk>
	<m1y7liyeyt.fsf@ebiederm.dsl.xmission.com>
	<4609E04D.408@blueyonder.co.uk> <20070328041407.GM16477@stusta.de>
Date: Wed, 28 Mar 2007 07:17:42 -0600
In-Reply-To: <20070328041407.GM16477@stusta.de> (Adrian Bunk's message of
	"Wed, 28 Mar 2007 06:14:07 +0200")
Message-ID: <m11wj9qzgp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:


> I think I got your problem:
>
> After rebooting, you do "git bisect [bad|good]"  *once*.
>
> Then recompile the kernel from the current tree, reboot, and again
> *once* "git bisect [bad|good]".
>
> etc.

Sounds right.

Someone else doing the bisect suggested that
0475ac0845f9295bc5f69af45f58dff2c104c8d1 is the problem commit.
Unfortunately I can't see anything wrong there.

Sid when you get that far if you can confirm or deny that
0475ac0845f9295bc5f69af45f58dff2c104c8d1 is the problem commit
I would appreciate the extra data point.  Having two people
report the problem at the exact same place would confirm for
me that we actually have a good trace, and that I really am
blind.

Eric

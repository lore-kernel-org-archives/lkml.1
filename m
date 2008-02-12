Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbYBLVou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbYBLVou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYBLVon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:44:43 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:55718 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbYBLVom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:44:42 -0500
Message-ID: <47B21327.3080502@tlinx.org>
Date: Tue, 12 Feb 2008 13:44:07 -0800
From: Linda Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: David Chinner <dgc@sgi.com>, Linux-Xfs <linux-xfs@oss.sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfs [_fsr] probs in 2.6.24.0
References: <47B0F00D.3060802@tlinx.org> <20080212085802.GA155407@sgi.com> <47B2094D.50406@tlinx.org> <47B20E84.6020707@sandeen.net>
In-Reply-To: <47B20E84.6020707@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Eric Sandeen wrote:
> Linda Walsh wrote:
>> David Chinner wrote:
>>> Filesystem bugs rarely hang systems hard like that - more likely is
>>> a hardware or driver problem. And neither of the lockdep reports
>>> below are likely to be responsible for a system wide, no-response
>>> hang.
>> ---
>> 	"Ish", the 32-bitter, has been the only hard-hanger.
> 
> 4k stacks?
----
	But but but...almost from the day they were introduced.  And
these are more recent probs. Has stack usage increased for some reason,
:-(.  I do have the option to detect stack-overflow turned on as well
-- guess it doesn't work so well?

	If they are that problematic, maybe selecting xfs as a config
option should force 8k stacks (ugly solution, but might eliminate
some lost hair (from pulling it out) for end users....?

	Guess I should go back to 8k's for now...seems odd that it'd
pop up now, but maybe it's the xtra NFS loading?  Sigh.

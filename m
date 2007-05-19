Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbXESLsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbXESLsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 07:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbXESLsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 07:48:25 -0400
Received: from ns.suse.de ([195.135.220.2]:40373 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763330AbXESLsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 07:48:22 -0400
From: Andi Kleen <ak@suse.de>
To: Dave Jones <davej@redhat.com>
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64 II
Date: Sat, 19 May 2007 13:47:44 +0200
User-Agent: KMail/1.9.1
Cc: Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
References: <464B9D2C.7040704@cv-sv.de> <200705190753.16570.ak@suse.de> <20070519060250.GA20061@redhat.com>
In-Reply-To: <20070519060250.GA20061@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705191347.44866.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2007 08:02, Dave Jones wrote:
> On Sat, May 19, 2007 at 07:53:16AM +0200, Andi Kleen wrote:
>  > This preserves the 6 <= model  <= 9 logic of the C code; this means
>  > if VIA ever brings out model >= 10 it hopefully sets this bit by
>  > default. Dave, do you have any information to the contrary?
>
> Model 10 (Esther) has the same feature.

Hmm nasty. Is it safe to assume that all VIA family == 6 will have that
MSR with the bit doing the same?

Perhaps we need some Centaur contact for guidance on this. Do you
have a current one? 

-Andi (who failed even to find current datasheets on the VIA website) 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYGKVYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYGKVYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760197AbYGKVYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:24:32 -0400
Received: from outbound-mail-150.bluehost.com ([67.222.38.40]:57720 "HELO
	outbound-mail-150.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760754AbYGKVYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:24:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=Jaht4QQu//bY+qfKfdZbYpApLScslpXRBdJXSvzqYA9aJLHCYK7r8mhpoXzyWPt0W+8SK6JYB3fT3U+ka/+EBXVTgpL97VLALIA+GNxDtzGztbhnE58L9BeizitJERPn;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] x86/pci: Renaming numa into numaq
Date: Fri, 11 Jul 2008 14:24:20 -0700
User-Agent: KMail/1.9.9
Cc: Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
References: <1215771521-6848-1-git-send-email-robert.richter@amd.com> <20080711192733.GA32623@elte.hu>
In-Reply-To: <20080711192733.GA32623@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111424.21147.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 66.205.146.252 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 11, 2008 12:27:33 pm Ingo Molnar wrote:
> * Robert Richter <robert.richter@amd.com> wrote:
> > This patch series renames numa into numaq for x86/pci code.
>
> applied to tip/x86/unify-pci:
>
>   Robert Richter (5):
>        x86/pci: Removing pci-y in Makefile
>        x86/pci: Changing subsystem initialization order for NUMA
>        x86/pci: renamed: numa.c -> numaq_32.c
>        x86/pci: renaming numa into numaq
>        x86/pci: Changing subsystem init for visws
>
> thanks Robert.
>
> Jesse, do you give us a general Ack for this direction and these
> commits? The changes are way too intermixed with other x86 bits to be
> cleanly separable at this stage, so it would be nice if we merged this
> via the x86 tree. Find below a list of commit IDs that change
> arch/x86/pci/ - all but the last few ones are in linux-next as well.

Yeah, no problem with the general direction.  I'll re-review Robert's latest 
stuff when I get a chance, but it looked pretty good to me in the first pass.

Thanks,
Jesse

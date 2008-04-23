Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYDWIF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYDWIF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYDWIFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:05:11 -0400
Received: from rv-out-0708.google.com ([209.85.198.250]:32988 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751668AbYDWIFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X9TctmfwN1jG/1/lQSdTpZ93nEq9GKaXMG0OVTrw5NF+gVRfaYRYDgG4EDUpeU7B2I22gp0JF1Zm1f/bdo9/4OHE7/2mJeq+xoLm9mlDFuinNbMvnB9UnCycQR4jN7WRsfgmy5gUyOa6CCa5CCLbguiZ5yoEl2pVbJi4K9XfQ0w=
Subject: Re: [PATCH 2/2] x86: Further shrink ifdef sections in fault.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Henry Nestler <henry-20071123@arcor.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <480E859D.80105@arcor.de>
References: <9Plf4-3KR-11@gated-at.bofh.it> <9PuLt-2sk-33@gated-at.bofh.it>
	 <480E859D.80105@arcor.de>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 01:05:05 -0700
Message-Id: <1208937905.5727.29.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 02:41 +0200, Henry Nestler wrote:
> Ingo Molnar wrote:
> > * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > 
> >> +	if (!(address >= VMALLOC_START && address < VMALLOC_END))
> >> +		return -1;
> > 
> > ah, this explains the weird chunk in your other patch.
> 
> Why this is not in x86_32?
> 
> Please see my other mail "x86: endless page faults in mount_block_root
> for Linux 2.6"
> 

Hmm, no idea why it wasn't in the 32-bit version.  Looks like something
fixed in the 64 bit versions but not 32-bit.

See:

commit 3b9ba4d5e23fcab24dd4d2e46dce11f5863869b4
commit f95190b28daa1bebf78ab5ec4129d01a223982c5


Cheers,

Harvey


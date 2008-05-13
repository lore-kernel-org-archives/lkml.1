Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbYEMPZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbYEMPZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYEMPZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:25:25 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:47144 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYEMPZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:25:24 -0400
Message-ID: <4829B32F.9060301@keyaccess.nl>
Date: Tue, 13 May 2008 17:26:39 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Takashi Iwai <tiwai@suse.de>, Glauber Costa <gcosta@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
References: <4823AAF2.7070102@keyaccess.nl> <s5hzlr0105c.wl%tiwai@suse.de> <48243D86.7020504@keyaccess.nl> <20080509122828.GB10855@elte.hu> <4824D79C.7060303@keyaccess.nl> <20080513143619.GA1714@elte.hu>
In-Reply-To: <20080513143619.GA1714@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-05-08 16:36, Ingo Molnar wrote:

> generally we prefer append-only repositories for public trees.
> 
> But as long as you've not pushed it out to others yet, i.e. it's a 
> purely local development tree, you can use two methods:
> 
> If it's just one commit in some devel branch that you want to put into a 
> 'fixes' branch one you can use git-cherry-pick --edit to shuffle it 
> over.
> 
> For more complex scenarios you can use git-rebase --interactive to 
> rebase your commits and to edit them. Replace the command "pick" with 
> "edit" to change/fix the commit message. "squash" can be used to fold 
> fixes.

Many thanks. Had in fact failed to notice --edit and will definitely 
check out the interactive rebase. Sounds very useful.

Rene.

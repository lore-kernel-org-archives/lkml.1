Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZFCRcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZFCRcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZFCRbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:31:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:18381 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbZFCRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:31:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906031018550.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com>
	 <20090602203405.GC6701@oblivion.subreption.com>
	 <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
	 <1244041914.12272.64.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0906031134410.13551@gentwo.org>
	 <20090603162831.GF6701@oblivion.subreption.com>
	 <4A26A689.1090300@redhat.com>
	 <alpine.LFD.2.01.0906030944440.4880@localhost.localdomain>
	 <7e0fb38c0906031016m77416390v37fb0673e6e50501@mail.gmail.com>
	 <alpine.LFD.2.01.0906031018550.4880@localhost.localdomain>
Date: Wed, 3 Jun 2009 13:31:56 -0400
Message-ID: <7e0fb38c0906031031t551f566fxc4ff2f08a73f807f@mail.gmail.com>
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
	ZERO_SIZE_PTR to point at unmapped space)
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, "Larry H." <research@subreption.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 1:28 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 3 Jun 2009, Eric Paris wrote:
>>
>> I am at least interested in hearing about the 'performance plummet.'
>
> It's perhaps not so much SElinux itself, but the AUDIT support (which it
> requires) that is really _very_ noticeable on microbenchmarks.
>
> Last time I ran lmbench on a Fedora kernel it was horrible. Turning off
> AUDIT (which also turns off SElinux) fixes it.
>
> It may be crazy distro auditing rules or whatever, but that doesn't change
> the basic issue.

Probably AUDITSYSCALL, not AUDIT.  SELinux only needs AUDIT.  I'll
poke that too someday, thanks.

-Eric

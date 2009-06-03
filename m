Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbZFCQsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbZFCQsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZFCQsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:48:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753592AbZFCQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:48:05 -0400
Date: Wed, 3 Jun 2009 09:47:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rik van Riel <riel@redhat.com>
cc: "Larry H." <research@subreption.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <4A26A689.1090300@redhat.com>
Message-ID: <alpine.LFD.2.01.0906030944440.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com>
 <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com> <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <1244041914.12272.64.camel@localhost.localdomain> <alpine.DEB.1.10.0906031134410.13551@gentwo.org>
 <20090603162831.GF6701@oblivion.subreption.com> <4A26A689.1090300@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Rik van Riel wrote:
> 
> Would anybody paranoid run their system without SELinux?

You make two very fundamental mistakes.

The first is to assume that this is about "paranoid" people. Security is 
_not_ about people who care deeply about security. It's about everybody. 
Look at viruses and DDoS attacks - the "paranoid" people absolutely depend 
on the _non_paranoid people being secure too!

The other mistake is to think that SELinux is sane, or should be the 
default. It's a f*cking complex disaster, and makes performance plummet on 
some things. I turn it off, and I know lots of other sane people do too. 
So the !SElinux case really does need to work.

				Linus

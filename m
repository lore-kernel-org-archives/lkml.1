Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZFCRXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZFCRXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZFCRWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:22:55 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:34221 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZFCRWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:22:54 -0400
Date: Wed, 3 Jun 2009 10:24:40 -0700
From: "Larry H." <research@subreption.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
	ZERO_SIZE_PTR to point at unmapped space)
Message-ID: <20090603172440.GA18561@oblivion.subreption.com>
References: <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com> <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com> <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <1244041914.12272.64.camel@localhost.localdomain> <alpine.DEB.1.10.0906031134410.13551@gentwo.org> <20090603162831.GF6701@oblivion.subreption.com> <4A26A689.1090300@redhat.com> <alpine.LFD.2.01.0906030944440.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906030944440.4880@localhost.localdomain>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:47 Wed 03 Jun     , Linus Torvalds wrote:
> 
> 
> On Wed, 3 Jun 2009, Rik van Riel wrote:
> > 
> > Would anybody paranoid run their system without SELinux?
> 
> You make two very fundamental mistakes.
> 
> The first is to assume that this is about "paranoid" people. Security is 
> _not_ about people who care deeply about security. It's about everybody. 
> Look at viruses and DDoS attacks - the "paranoid" people absolutely depend 
> on the _non_paranoid people being secure too!
> 
> The other mistake is to think that SELinux is sane, or should be the 
> default. It's a f*cking complex disaster, and makes performance plummet on 
> some things. I turn it off, and I know lots of other sane people do too. 
> So the !SElinux case really does need to work.

I'm finally glad we start finding points where we both agree. riel is
talking from the perspective of someone who deals with RHEL/Fedora... so
I could see his inclination towards SELinux over any other
possibilities.

But people without SELinux must be definitely taken care of, and kept
safe whenever possible, if technical circumstances allow this to happen.

	Larry


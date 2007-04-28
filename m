Return-Path: <linux-kernel-owner+w=401wt.eu-S1163383AbXD1SD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163383AbXD1SD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163354AbXD1SD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:03:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:39181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163383AbXD1SDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:03:35 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
Date: Sat, 28 Apr 2007 20:03:29 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <4632AE54.7030200@goop.org> <200704281229.48597.ak@suse.de> <m1r6q4e7kk.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6q4e7kk.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704282003.30118.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 April 2007 19:23:55 Eric W. Biederman wrote:
> Andi Kleen <ak@suse.de> writes:
> 
> >> My preference would be for whoever had:
> >> paravirt_ops-hooks-to-set-up-initial-pagetable.patch
> >
> > That would be very messy because there are many followup dependencies.
> >
> > But once we have a good fix aggreed by everybody I can merge it into the 
> > initial patch then.
> 
> I don't see Xen patches merged yet in your tree yet.

Hmm, I thought you were talking about paravirt-initial-pagetable ?

That one is in my tree already. The Xen patches that are still outstanding
iirc are all addons patches, as they don't impact existing code paths anymore.

-Andi

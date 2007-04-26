Return-Path: <linux-kernel-owner+w=401wt.eu-S1423465AbXDZAeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423465AbXDZAeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423467AbXDZAeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:34:21 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34807 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423465AbXDZAeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:34:20 -0400
Date: Wed, 25 Apr 2007 17:33:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
Message-ID: <20070426003337.GB2819@sequoia.sous-sol.org>
References: <4627DDAD.4070805@redhat.com> <4627E099.209@goop.org> <m1abwwqiof.fsf@ebiederm.dsl.xmission.com> <462FC8CD.1030505@goop.org> <m11wi8qflo.fsf@ebiederm.dsl.xmission.com> <462FD0EF.5050706@goop.org> <m1tzv4p079.fsf@ebiederm.dsl.xmission.com> <462FDBB4.8020604@goop.org> <m14pn4owpy.fsf@ebiederm.dsl.xmission.com> <462FE728.5060802@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462FE728.5060802@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Eric W. Biederman wrote:
> > Then why you had to allocate enough pages to cause a failure has me stumped.
> > Perhaps there is some other bug?
> 
> Perhaps, but nothing comes to mind. I'll see what happens when I boot
> this kernel on real hardware (rather than kvm).

I was using real hardware with your .config when I reproduced it.

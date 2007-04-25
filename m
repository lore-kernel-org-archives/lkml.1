Return-Path: <linux-kernel-owner+w=401wt.eu-S1422786AbXDYWUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422786AbXDYWUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422801AbXDYWUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:20:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36872 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422786AbXDYWUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:20:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
References: <20070414204154.871250608@goop.org>
	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>
	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>
	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>
	<m1abwwqiof.fsf@ebiederm.dsl.xmission.com> <462FC8CD.1030505@goop.org>
	<m11wi8qflo.fsf@ebiederm.dsl.xmission.com> <462FD0EF.5050706@goop.org>
Date: Wed, 25 Apr 2007 16:18:34 -0600
In-Reply-To: <462FD0EF.5050706@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 25 Apr 2007 15:06:39 -0700")
Message-ID: <m1tzv4p079.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> And it just occurred to me PSE disabled, otherwise you would not have
>> needed more than 4 pages.  I supposed you were testing the Xen case.
>>   

>
> No, actually, I wasn't.  It was booting native (the Xen boot path
> doesn't go that way), and it should have booted like a normal native
> kernel despite having Xen compiled in.  Hm, not sure why it wouldn't be
> using the PSE path.

Since you have PSE disabled for Xen my hunch is that somehow that
got left on for your test boot.

Eric

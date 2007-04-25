Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbXDYXfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbXDYXfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXDYXfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:35:55 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39256 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbXDYXfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:35:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
	<m1tzv4p079.fsf@ebiederm.dsl.xmission.com> <462FDBB4.8020604@goop.org>
Date: Wed, 25 Apr 2007 17:33:45 -0600
In-Reply-To: <462FDBB4.8020604@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 25 Apr 2007 15:52:36 -0700")
Message-ID: <m14pn4owpy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> Since you have PSE disabled for Xen my hunch is that somehow that
>> got left on for your test boot.
>
> No.  Under Xen cpuid masks out PSE (and complains if you try to set it
> in a pte), but when booting native it will just use a plain unadorned cpuid.

Then why you had to allocate enough pages to cause a failure has me stumped.
Perhaps there is some other bug?

Eric

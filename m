Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbXDYWGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbXDYWGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbXDYWGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:06:07 -0400
Received: from gw.goop.org ([64.81.55.164]:33922 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbXDYWGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:06:04 -0400
Message-ID: <462FD0EF.5050706@goop.org>
Date: Wed, 25 Apr 2007 15:06:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org>	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>	<m1abwwqiof.fsf@ebiederm.dsl.xmission.com> <462FC8CD.1030505@goop.org> <m11wi8qflo.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m11wi8qflo.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> And it just occurred to me PSE disabled, otherwise you would not have
> needed more than 4 pages.  I supposed you were testing the Xen case.
>   

No, actually, I wasn't.  It was booting native (the Xen boot path
doesn't go that way), and it should have booted like a normal native
kernel despite having Xen compiled in.  Hm, not sure why it wouldn't be
using the PSE path.

    J

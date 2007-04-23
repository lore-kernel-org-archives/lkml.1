Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbXDWRqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbXDWRqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbXDWRqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:46:50 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbXDWRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:46:49 -0400
Message-ID: <462CF0C5.2040200@zytor.com>
Date: Mon, 23 Apr 2007 10:45:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org>	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>	<m1d51vxxm4.fsf@ebiederm.dsl.xmission.com> <462CE027.4030302@goop.org>	<462CE1E0.9060007@zytor.com> <462CE69E.8040207@goop.org> <m1vefnvvyb.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1vefnvvyb.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> - I know of one system that had BIOS tables at 16MB I believe (and
>   thus had a fairly low hole).
> 

Please name names, otherwise this is just rumouring.  Seriously.  We 
have enough cargo-cult programming as it is.

A lot of old ISA systems had an option to put a memory hole at 15-16 MB 
to support ISA video cards with linear frame buffer.  It very rarely got 
used, since VLB took over around the same time.

	-hpa

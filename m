Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbXDWUmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbXDWUmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbXDWUmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:42:39 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35362 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbXDWUmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:42:38 -0400
Message-ID: <462D1A02.5060403@zytor.com>
Date: Mon, 23 Apr 2007 13:41:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org>	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>	<m1d51vxxm4.fsf@ebiederm.dsl.xmission.com> <462CE027.4030302@goop.org>	<462CE1E0.9060007@zytor.com>	<m1zm4zvwfr.fsf@ebiederm.dsl.xmission.com>	<462CF5B8.4070708@xensource.com>	<m1y7kivs3s.fsf@ebiederm.dsl.xmission.com> <462D04B2.6080008@goop.org>	<462D05A0.1020100@zytor.com> <462D072F.6030809@goop.org> <m1r6qavq0y.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6qavq0y.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> 
>> H. Peter Anvin wrote:
>>> It would be *trivial* to make a certain number of page table slots
>>> available at the end of the head.S-generated map. 
>> Or you could use a fixmap.
> 
> That certain number of page table slots should be the fixmap slots.
> If you do that bt_ioremap works, we remove a boatload of special cases
> and the code becomes simpler.

It's probably worth noting that several of the non-PC ports already do 
exactly this, although in a hacky way.  Grep for pg0 and you'll find it.

	-hpa

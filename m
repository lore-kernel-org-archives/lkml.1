Return-Path: <linux-kernel-owner+w=401wt.eu-S1422942AbXEDTUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422942AbXEDTUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423018AbXEDTUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:20:23 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59757 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422942AbXEDTUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:20:22 -0400
Message-ID: <463B8732.4060808@zytor.com>
Date: Fri, 04 May 2007 12:19:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] Replace paravirt_probe with "platform type" boot
 header field
References: <1178283582.23670.67.camel@localhost.localdomain>	<m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>	<1178288329.23670.86.camel@localhost.localdomain>	<m1tzussm4z.fsf@ebiederm.dsl.xmission.com>	<463B56A0.7090805@zytor.com>	<m1mz0kr0ux.fsf@ebiederm.dsl.xmission.com>	<463B69AB.2030706@zytor.com>	<m1vef8phjy.fsf@ebiederm.dsl.xmission.com>	<463B81BC.1030504@zytor.com> <m1d51gpfqn.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d51gpfqn.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> I'm working on it!!!!!
> 
> Sure. I meant that linux/screen_info.h should already be safe.

Just pushed out a change which removes pretty much all the header
duplication into the git tree.

	-hpa

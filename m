Return-Path: <linux-kernel-owner+w=401wt.eu-S1767940AbXEEBuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767940AbXEEBuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767941AbXEEBuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:50:10 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767940AbXEEBuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:50:09 -0400
Message-ID: <463BE2C7.9010707@zytor.com>
Date: Fri, 04 May 2007 18:49:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org>	<m1r6pwu806.fsf@ebiederm.dsl.xmission.com> <463B49F0.401@goop.org>	<463B5643.1040204@zytor.com>	<m1ejlwr036.fsf@ebiederm.dsl.xmission.com> <463B6888.20001@zytor.com>	<m17iroqzlq.fsf@ebiederm.dsl.xmission.com>	<463B6CCE.4050800@zytor.com>	<m1hcqspg7c.fsf@ebiederm.dsl.xmission.com>	<463BBEEE.3000903@zytor.com> <m1r6pwniv1.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6pwniv1.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I have this vague memory of liking 0x3c because if we do happen to use
> more room then we intended the consequences are pretty benign.
> 
> But that is a pretty minor consequence.
> 

That's a dangerous assumption (besides, it's likely wrong, since there
are only two unused bytes below it.)

	-hpa

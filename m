Return-Path: <linux-kernel-owner+w=401wt.eu-S1161303AbXEDR05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161303AbXEDR05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbXEDR05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:26:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54401 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbXEDR04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:26:56 -0400
Message-ID: <463B6CCE.4050800@zytor.com>
Date: Fri, 04 May 2007 10:26:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org>	<m1r6pwu806.fsf@ebiederm.dsl.xmission.com> <463B49F0.401@goop.org>	<463B5643.1040204@zytor.com>	<m1ejlwr036.fsf@ebiederm.dsl.xmission.com> <463B6888.20001@zytor.com> <m17iroqzlq.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m17iroqzlq.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> Oh, right.  And this runs with interrupts off, so you only need one
>> dword.  That's fine, of course, although the location is a bit awkward.
> 
> Yep.  That is what I found when surveyed the available locations.

Look at the structure definition I just posted; I think you'll find that
using something not in the immediate extension area for the video area
would have been preferrable, I would suggest 0x5c or 0x1e4.

	-hpa

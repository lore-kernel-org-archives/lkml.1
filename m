Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbZCMXdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbZCMXdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 19:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZCMXdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 19:33:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34794 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZCMXdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 19:33:16 -0400
Message-ID: <49BAECE6.7060009@zytor.com>
Date: Fri, 13 Mar 2009 16:31:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: relocs is only used with 32bit
References: <49B80F7B.2020007@kernel.org> <49B88F80.3080203@zytor.com> <m1mybpt5t8.fsf@fess.ebiederm.org>
In-Reply-To: <m1mybpt5t8.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>
>> In general I prefer minimizing the conditional sections rather than
>> maximizing them.  If nothing else, it catches errors earlier that way,
>> and makes it easier to eventually eliminate them entirely.
> 
> Makes sense.  Although in this case that rule appears like it
> can't even execute on x86_64.
> 

That's fine.  This is the same reason why it's better to have
if () { ... } than #ifdef as long as the condition can be statically 
determined -- at least this way make will complain about a syntax error.

	-hpa

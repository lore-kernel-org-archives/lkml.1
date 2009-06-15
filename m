Return-Path: <linux-kernel-owner+w=401wt.eu-S1763227AbZFOQww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763227AbZFOQww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbZFOQwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:52:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45377 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbZFOQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:52:45 -0400
Message-ID: <4A367C09.80008@zytor.com>
Date: Mon, 15 Jun 2009 09:51:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>	 <20090612180626.GB18203@uranus.ravnborg.org>	 <1245079002.17481.118.camel@nathan.suse.cz> <1245079649.17481.121.camel@nathan.suse.cz>
In-Reply-To: <1245079649.17481.121.camel@nathan.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik wrote:
> Petr Tesarik píše v Po 15. 06. 2009 v 17:16 +0200:
>> [...]
>> An example can probably explain it better:
>>
>> $ cat >shared.c <<EOF
>> int shared_object[100];
>> EOF
>> $ cat >exe.c <<EOF
>> #include <stdio.h>
>> extern int shared_object[100];
>> int main(void) {
>> 	printf("%p\n", &shared_object); 
>> 	return 0;
>> }
>> EOF
> 
> BTW this example demonstrates that there is one section which should be
> included in .data but is not:
> 
> 	*(COMMON)
> 
> I'll send a patch later.
> 

*(COMMON) is BSS, not data...

	-hpa

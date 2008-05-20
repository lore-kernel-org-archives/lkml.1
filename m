Return-Path: <linux-kernel-owner+w=401wt.eu-S935657AbYETWoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935657AbYETWoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935299AbYETWk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:40:27 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:57883 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935295AbYETWk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:40:26 -0400
Message-ID: <483353DB.7010708@keyaccess.nl>
Date: Wed, 21 May 2008 00:42:35 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dave Jones <davej@redhat.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Add a boot parameter to force-enable PAT
References: <200805200409.m4K49Ybn024338@gelk.kernelslacker.org> <86802c440805192253s34b3acb2r63c657db86676792@mail.gmail.com> <20080520132306.GB4843@redhat.com> <18482.58121.130009.555407@harpo.it.uu.se> <20080520195846.GA29806@redhat.com> <48334766.1020701@keyaccess.nl> <48334EFA.3070109@zytor.com>
In-Reply-To: <48334EFA.3070109@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-05-08 00:21, H. Peter Anvin wrote:

> Rene Herman wrote:
>>> +}
>>> +__setup("enablepat", x86_forcepat_setup);
>>
>> This should probably be called plain "pat" to mirror arch/x86/mm/pat.c 
>> "nopat" force off parameter. That by the way is an early_param which I 
>> guess this should then also be?
>>
> 
> Either that or "pat={off,on,force}" to give space for other options... 
> would mean keeping "nopat" around as an alias for now, though...

Yes, that would be nicer. As to the alias; "nopat" hasn't been in a 
released kernel yet so should be okay to do away with? It's not like 
it's in Documentation/kernel-parameters.txt or anything... ;-/

Rene.

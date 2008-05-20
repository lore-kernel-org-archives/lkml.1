Return-Path: <linux-kernel-owner+w=401wt.eu-S934501AbYETWZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbYETWZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764648AbYETWZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:25:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758154AbYETWZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:25:35 -0400
Message-ID: <48334EFA.3070109@zytor.com>
Date: Tue, 20 May 2008 15:21:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Dave Jones <davej@redhat.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Add a boot parameter to force-enable PAT
References: <200805200409.m4K49Ybn024338@gelk.kernelslacker.org> <86802c440805192253s34b3acb2r63c657db86676792@mail.gmail.com> <20080520132306.GB4843@redhat.com> <18482.58121.130009.555407@harpo.it.uu.se> <20080520195846.GA29806@redhat.com> <48334766.1020701@keyaccess.nl>
In-Reply-To: <48334766.1020701@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
>> +}
>> +__setup("enablepat", x86_forcepat_setup);
> 
> This should probably be called plain "pat" to mirror arch/x86/mm/pat.c 
> "nopat" force off parameter. That by the way is an early_param which I 
> guess this should then also be?
> 

Either that or "pat={off,on,force}" to give space for other options... 
would mean keeping "nopat" around as an alias for now, though...

	-hpa

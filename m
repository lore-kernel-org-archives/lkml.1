Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYAVUoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYAVUoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYAVUoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:44:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51051 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYAVUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:44:07 -0500
Message-ID: <47965555.60308@zytor.com>
Date: Tue, 22 Jan 2008 12:43:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Campbell <ijc@hellion.org.uk>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk> <47939363.8040603@kolumbus.fi> <1200950633.15491.21.camel@cthulhu.hellion.org.uk> <479510CE.7010706@zytor.com> <1200951996.15491.28.camel@cthulhu.hellion.org.uk> <479551FD.5040801@zytor.com> <1201023401.5643.52.camel@localhost.localdomain> <479634A9.1090908@zytor.com> <1201031325.15491.66.camel@cthulhu.hellion.org.uk> <47964B7B.9000905@zytor.com> <20080122203611.GA12892@elte.hu>
In-Reply-To: <20080122203611.GA12892@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>>> Seems reasonable to me. I'll integrate your asm diff with the other 
>>> changes and give it a whirl.
>> This version boots into userspace on both PAE and !PAE.  You want to 
>> take it from here?
> 
> ok, i'll wait for Ian to submit the final (tested) version then. A few 
> possible complications are: PSE-less boxes, 32-bit PAGEALLOC bootups 
> with tons of RAM, NX-less boxes and NX-able boxes :)

PSE-less should be less of an issue than making sure we switch to using 
large pages where appropriate, and enable the PGE and NX bits where 
appropriate.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYHAPRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYHAPRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYHAPRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:17:08 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:48691 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYHAPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:17:07 -0400
Message-ID: <48932975.80508@keyaccess.nl>
Date: Fri, 01 Aug 2008 17:19:17 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Wolfram Sang <w.sang@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       =?ISO-8859-15?Q?P=E1draig_Brady?= <P@draigBrady.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
References: <20080730234102.GF11223@linux-os.sc.intel.com> <20080731212915.GH2729@elte.hu> <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221435.GS23938@one.firstfloor.org> <20080731221924.GD8563@linux-os.sc.intel.com> <alpine.LFD.1.10.0807311531271.3277@nehalem.linux-foundation.org> <20080731225004.GD22426@elte.hu> <48926FC3.3000706@keyaccess.nl> <20080801095105.GA18055@elte.hu> <48931D69.2010309@keyaccess.nl> <20080801144917.GY23938@one.firstfloor.org>
In-Reply-To: <20080801144917.GY23938@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-08-08 16:49, Andi Kleen wrote:

>> For real ISA at the least, the best fix I feel is just not go grabbing 
>> resources without anything (ie, ISAPnP) or anyone (ie, the user) telling 
> 
> Really old systems don't have isapnp. Neither have smbus devices.
> 
>> us that's where the hardware's at.
> 
> That would mean the users on these systems would need to add tons
> of obscure command line options.

No, it means users on those 1% of systems that are using drivers that 
break the other 99% would have to for those one or two drivers that do.

And as said, we don't care.

Rene.

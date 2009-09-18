Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZIRAxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZIRAxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZIRAxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:53:31 -0400
Received: from claw.goop.org ([74.207.240.146]:38400 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZIRAxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:53:30 -0400
Message-ID: <4AB2DA0D.8020606@goop.org>
Date: Thu, 17 Sep 2009 17:53:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com> <20090918003412.GI26034@sequoia.sous-sol.org>
In-Reply-To: <20090918003412.GI26034@sequoia.sous-sol.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/09 17:34, Chris Wright wrote:
>> One of the options that I am contemplating is to drop the code from the
>> tip tree in this release cycle, and given that this should be a low risk
>> change we can remove it from Linus's tree later in the merge cycle.
>>
>> Let me know your views on this or if you think we should do this some
>> other way.
>>     
> Typically we give time measured in multiple release cycles
> before deprecating a feature.  This means placing an entry in
> Documentation/feature-removal-schedule.txt, and potentially
> adding some noise to warn users they are using a deprecated
> feature.
>   

That's true if the feature has some functional effect on users.  But at
first sight, VMI is really just an optimisation, and a non-VMI-equipped
kernel would be completely functionally equivalent, right?

On the other hand, there could well be a performance regression which
could affect users.  However they're taking the explicit step of
withdrawing support for VMI, so I guess they can just take that in their
stride.

    J

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYGLGGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYGLGGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 02:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYGLGGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 02:06:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:51974 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYGLGGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 02:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TjUdFc+Td4DTREHQrFGWz1UJDqaVQa7WuyV5VAZyhLrJT+gGf21C1CQSDdHCd6ce84
         CoVrm7pKZ2714wPWPcH5KYdg7JdpQAHP9f2ybxEcYs7R/pnQ/EkhKHrUo/wX4fB3Gk1m
         TXFaj3BtLH2QhCyiN5UoQYo0NzZIUnZ6nml40=
Message-ID: <86802c440807112306h6b396cd3ycf6bf490d6c2ccf9@mail.gmail.com>
Date: Fri, 11 Jul 2008 23:06:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
In-Reply-To: <20080712053713.GA341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710181634.764954000@linux-os.sc.intel.com>
	 <20080710215617.GM1678@linux-os.sc.intel.com>
	 <20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu>
	 <20080711203151.GU1678@linux-os.sc.intel.com>
	 <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com>
	 <20080711204521.GA15689@elte.hu>
	 <20080711212418.GV1678@linux-os.sc.intel.com>
	 <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com>
	 <20080712053713.GA341@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 10:37 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> > Yinghai, Can you please try the appended patch to see if it fixes
>> > your problem?
>
>> works. it should be merged into the patch that introduce new
>> read_apic_id
>
> ok, that came from the x86/uv branch - but in that form it was not
> affected, only tip/x2apic exposed the problem, right?

because of new read_apic_id()

>
> So i've rebased tip/x86/x2apic and moved Suresh's fix in front of the
> other patches, to make it all bisectable.

should incorperate that fix into the patch that introduce new read_apic_id()

commit df8cc50cc9357ba5a5d6a07744fa36b16a81121c
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Thu Jul 10 11:16:48 2008 -0700

    x64, x2apic/intr-remap: introduce read_apic_id() to genapic routines

    Move the read_apic_id()  to genapic routines.

YH

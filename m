Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYKJKb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYKJKb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYKJKbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:31:50 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:17634 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYKJKbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:31:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YCnrfhKBG2uJpStS0hvM+x5aDDRa5Dt5dPhoPunIVeMbLV/GmZVX+3pzGfiCzpA9D5
         bXxAxjVk6ZWdOo7fZe0dIKFO6G/RoTeHaBnrHzWGQl67N4RW0jVRC8tl50/dxskv+Z+X
         3GykcURis1ErenaL18RowmHDmYl7ot0Ku5VrQ=
Message-ID: <8d6898730811100231j2ca5e8ceub0d5137c1ef1f9d0@mail.gmail.com>
Date: Mon, 10 Nov 2008 16:01:47 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: sharing interrupt between PCI device
Cc: "Jiri Slaby" <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, "Robert Hancock" <hancockr@shaw.ca>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081110075827.GE2093@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>
	 <4910E8AC.7050407@shaw.ca>
	 <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
	 <20081108172716.GA28039@colo.lackof.org> <4915E43E.4010206@gmail.com>
	 <20081108191536.GC28039@colo.lackof.org>
	 <8d6898730811092235u4a41c664vd641d2792dee4c50@mail.gmail.com>
	 <20081110075115.GA13239@colo.lackof.org>
	 <20081110075827.GE2093@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes USB Virtual Controller has input devices like keyboard and mouse
(routed through hpilo card (remote console)), so those things stops
working when we remove hpilo driver.

Thanks
Nobin Mathew

On Mon, Nov 10, 2008 at 1:28 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Grant Grundler <grundler@parisc-linux.org> wrote:
>
>> [+ingo - question for you about disable_irq() below]
>
>> The same problem exists with disable_irq() : only takes a global
>> IRQ# and no additional identifying information to prevent disabling
>> a shared IRQ. So I'm not sure if this is a bug with ACPI or design
>> flaw in generic IRQ APIs.  Ingo?
>
> that's how disable_irq() always worked: it disables all handlers on
> that IRQ#. If the IRQ# is shared, it disables all handlers.
>
>        Ingo
>

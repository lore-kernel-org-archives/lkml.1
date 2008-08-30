Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYH3TKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYH3TKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYH3TKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:10:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:46553 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYH3TKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FmMy+sdQoTmmvYwM0bthcV8cjQxHtH1EIzuu4XrDmGBuBsbiP/iZUsE5vigO3Iw35F
         S7Z2KEPHJ+1zXJ+qbVfMSetcxHRcuOeS1YR7noUvfvZY4hq5bGtSTDDvx96Ay4VlvBqV
         EZTS701VQUjMYfC6Kb1uk0+dsIuyXDjFbsmuI=
Message-ID: <86802c440808301210u6db1b4e7p4036bdc95db1a601@mail.gmail.com>
Date: Sat, 30 Aug 2008 12:10:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808292157.24179.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org>
	 <200808300030.32905.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
	 <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>
	 <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 11:43 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 30 Aug 2008, Yinghai Lu wrote:
>>
>> again, should use MCFG end as the res _end
>
> No. Again - we shouldn't DO that insane crap.
>
> We simply shouldn't try to compare the BAR start with randomly chosen
> things.

do you agree to use quirk to make the BAR res to have correct end
between pci_probe and pci_resource_survey?

YH

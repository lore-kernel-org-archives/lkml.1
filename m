Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYIYRBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYIYRBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYIYRBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:01:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:24487 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbYIYRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=uH0WpIqVWkSntR0GZglnnOqqQEHVEW3bRaTYDmtVFdNVm2l4V4/lZu6ztIoRfZBQWo
         3h2wnNhKKIssa6uIyGpR+qW6KWznMk4RG0I++4zF1mLOKJeGRnDUH4AVTPPHkSbPpmO3
         P0xxnQRpOsAyESuJ5PlgQIjaR+vXzxMH754fE=
Message-ID: <86802c440809251001vc9aa170vb6656ca6f61b1971@mail.gmail.com>
Date: Thu, 25 Sep 2008 10:01:40 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: mgross@linux.intel.com
Subject: Re: [PATCH] x86/pci: fix dmar_tbl early_ioremap leak v2
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <20080925162434.GA30374@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222327705-22048-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080925081158.GA30349@elte.hu>
	 <200809250743.35271.jbarnes@virtuousgeek.org>
	 <20080925162434.GA30374@linux.intel.com>
X-Google-Sender-Auth: 6fdaf88a1c5c5e88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 9:24 AM, mark gross <mgross@linux.intel.com> wrote:
> On Thu, Sep 25, 2008 at 07:43:34AM -0700, Jesse Barnes wrote:
>> On Thursday, September 25, 2008 1:11 am Ingo Molnar wrote:
>> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> > > use early_acpi_os_unmap_memory
>> > >
>> > > v2: move unmap_memory early...
>> > >
>> > > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> > >
>> > > ---
>> > >  drivers/pci/dmar.c |    9 +++++++--
>> > >  1 file changed, 7 insertions(+), 2 deletions(-)
>> >
>> > since this depends on other x2apic/sparseirq changes in -tip i've
>> > applied it to tip/irq/sparseirq.
>> >
>> > Jesse, any objections?
>>
>> Nope, but it would be good to get Dave or Mark's ack (Dave owns this code
>> now).
>>
> Sorry for the dumb question but where is acpi_get_table_with_size
> defined?  Its not in linus's git. /me goes and gets linux-next...
>

in tip/master

YH

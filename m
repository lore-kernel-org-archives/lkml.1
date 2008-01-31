Return-Path: <linux-kernel-owner+w=401wt.eu-S932613AbYAaVff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbYAaVff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759078AbYAaVf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:35:28 -0500
Received: from iona.labri.fr ([147.210.8.143]:39148 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274AbYAaVf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:35:28 -0500
Message-ID: <47A23F1C.7080809@inria.fr>
Date: Thu, 31 Jan 2008 22:35:24 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Paul Mundt <lethal@linux-sh.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Purpose of numa_node?
References: <47A11ACD.1090400@redhat.com> <20080131074045.GA13788@linux-sh.org>	 <47A1D03A.3020508@inria.fr> <86802c440801311329h67a79139xa33994e2cc116781@mail.gmail.com>
In-Reply-To: <86802c440801311329h67a79139xa33994e2cc116781@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Jan 31, 2008 5:42 AM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
>   
>> It works fine on regular machines such as dual opterons. However, I
>> noticed recently that it was wrong on some quad-opteron machines (see
>> http://marc.info/?l=linux-pci&m=119072400008538&w=2) because something
>> is not initialized in the right order. But I haven't tested 2.6.24 on
>> this hardware yet, and I don't know if things have changed regarding this.
>>     
>
> that will depend if you dsdt have _PXM for your pci root bus.
> otherwise you will get all -1
>   

Have a look at the above link. I don't get -1. I get 0 everywhere, while
I should get 1 for some devices. And if I unplug/replug a device using
fakephp, numa_node becomes correct (1 instead of 0). This just looks
like the code is there but things are initialized in the wrong order.

Brice



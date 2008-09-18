Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbYIRTWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbYIRTWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbYIRTWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:22:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbYIRTWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:22:30 -0400
Message-ID: <48D2A973.1050201@zytor.com>
Date: Thu, 18 Sep 2008 12:18:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dean Nelson <dcn@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Mayer <ajm@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
References: <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu> <20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu> <20080916204654.GA3532@sgi.com> <20080917173032.GA5674@sgi.com> <m17i9a61l2.fsf@frodo.ebiederm.org> <20080918133733.GA8830@sgi.com>
In-Reply-To: <20080918133733.GA8830@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dean Nelson wrote:
> On Wed, Sep 17, 2008 at 11:59:05AM -0700, Eric W. Biederman wrote:
>> I need to look at these patches some more (apologies I got busy).
> 
> Thanks for taking a look.
> 
> I've got a not-quite-complete new version of the patchset that addresses
> most of the issues raised by Ingo. At it's heart is the following:
> 

What would seem most intuitive to me would have been, in this case, to
add this as a new MSI IRQ chip type.  We already have several of those
(PCI vs HT), and this *should* give you all the hooks you need.

	-hpa


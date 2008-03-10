Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbYCJVIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbYCJVIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbYCJVIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:08:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54579 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYCJVIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:08:45 -0400
Message-ID: <47D5A000.6000407@zytor.com>
Date: Mon, 10 Mar 2008 21:54:24 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu> <20080309114640.85c9c3eb.akpm@linux-foundation.org> <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com> <87myp68r88.fsf@basil.nowhere.org> <Pine.LNX.4.64.0803101707070.3398@blonde.site> <47D57056.3050204@goop.org> <20080310175305.GC7692@one.firstfloor.org> <47D57F86.2020806@goop.org>
In-Reply-To: <47D57F86.2020806@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Yeah, the most fundamental problem is that the whole page is RO, so even 
> if Xen trapped and emulated, it still makes a very bad neighbour.  I was 
> also going to say that there's no reason why you couldn't pack multiple 
> pgds into one page, but I think we can only specify the cr3 at page 
> resolution anyway.
> 

Wrong.  With PAE you can specify it at any 32-byte boundary.

	-hpa


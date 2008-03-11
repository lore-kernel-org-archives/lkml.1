Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYCKMJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYCKMJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYCKMJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:09:46 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:51095 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYCKMJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:09:45 -0400
Message-Id: <47D63CB3.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 11 Mar 2008 06:02:59 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert "cpu hotplug: adjust
	root-domain->onlinespan in response to hotplug
References: <20080310205241.9571.38832.stgit@novell1.haskins.net>
 <20080311085201.GD25110@elte.hu>
In-Reply-To: <20080311085201.GD25110@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Mar 11, 2008 at  4:52 AM, in message <20080311085201.GD25110@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 

> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
>> This reverts commit 393d94d98b19089ec172566e23557997931b137e.
>> 
>> I submitted 393d94d98b1 to -mm and sched-devel, and then quickly 
>> realized it was flawed.  However, the patch was already "in flight" 
>> and made it to Linus' tree and is in .25-rc5.  So this patch reverts 
>> the original/flawed fix, and the patch that follows has the updated 
>> version.
> 
> yeah, but the patch fixed Andrew's regression and passed my testing so i 
> wanted to have _something_ in -rc5, even if we found the right fix.
> 
> i've applied your revert and the real fix now.


Hi Ingo,
  Understood, and no problem.  I just wanted to make sure I accurately described what I was doing ;)

Also, for the second patch, make sure you pick up "v2" which has both DYING/DYING_FROZEN.  The hotplug gurus indicated that I need both to work properly.

Thanks!

-Greg





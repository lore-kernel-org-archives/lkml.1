Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbZAOJP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbZAOJP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZAOJPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:15:36 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:44367 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbZAOJPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:15:34 -0500
Message-Id: <496F0CEB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 15 Jan 2009 09:16:11 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] conditionalize call from panic() to
	 smp_send_stop()
References: <496DE7CD.76E4.0078.0@novell.com><496DE7CD.76E4.0078.0@novell.com> (Jan
 Beulich's message of "Wed, 14 Jan 2009 12:25:33 +0000")
 <87wscxdyyf.fsf@basil.nowhere.org>
In-Reply-To: <87wscxdyyf.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 15.01.09 04:34 >>>
>"Jan Beulich" <jbeulich@novell.com> writes:
>
>> ... avoiding nested warnings and/or oopses as much as possible (namely
>> durin early boot).
>
>Better would be to fix smp_send_stop than to work around it for this
>very limited case. I've been running into this with machine checks
>too. The new fancy smp_call_function() that is there now just doesn't
>work in any unusual situation like early boot or fatal exceptions,

Indeed - I wasn't used to smp_call_function...() to be generic functions
that can be fixed for all architectures at once. I simply wanted to avoid
needing individual changes in all architectures...

Jan




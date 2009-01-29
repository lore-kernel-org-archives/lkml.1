Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZA2VEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZA2VEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZA2VEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:04:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZA2VEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:04:20 -0500
Message-ID: <498219C0.8070207@zytor.com>
Date: Thu, 29 Jan 2009 13:04:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old 
 subarchitecture code
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>	 <87vdryw6ql.fsf@basil.nowhere.org> <86802c440901291236k62f2fc21ma08655b4a13f3c4@mail.gmail.com>
In-Reply-To: <86802c440901291236k62f2fc21ma08655b4a13f3c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, Jan 29, 2009 at 6:02 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> Also bigsmp is kind of obsolete too, it could be probably
>> merged with default with very tiny impact because it's not
>> all that different.
> 
> yes bigsmp should not be treated non-standard.
> 

Yes, but one step at a time, please.  First let's clean up the subarch 
mess, and then we can worry about reunifying the operations that remain.

	-hpa


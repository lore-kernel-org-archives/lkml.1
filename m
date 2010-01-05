Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609Ab0AEOTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab0AEOTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518Ab0AEOT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:19:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58131 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab0AEOT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:19:27 -0500
To: paulmck@linux.vnet.ibm.com
Cc: ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/9] Add rcustring ADT for RCU protected strings v2
From: Andi Kleen <andi@firstfloor.org>
References: <20100105315.789846878@firstfloor.org>
	<20100105021526.17EF2B17C2@basil.firstfloor.org>
	<20100105053252.GB6836@linux.vnet.ibm.com>
	<20100105104746.GB1778@basil.fritz.box>
	<20100105141146.GD6836@linux.vnet.ibm.com>
Date: Tue, 05 Jan 2010 15:19:24 +0100
In-Reply-To: <20100105141146.GD6836@linux.vnet.ibm.com> (Paul E. McKenney's message of "Tue, 5 Jan 2010 06:11:46 -0800")
Message-ID: <871vi4d47n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>> 
>> I would consider it disallowed, all the strings have some default value.
>> Empty string would be ""
>> 
>> If we allowed it the caller couldn't easily distingush error from expected NULL.
>
> OK, then:

Thanks. I actually changed my mind and added support for NULL strings
(although I suspect they are not too useful)

I also found one more minor problem (and there was one conversion
missing in v2), will do a repost later

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

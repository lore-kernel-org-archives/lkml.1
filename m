Return-Path: <linux-kernel-owner+w=401wt.eu-S1762137AbZDQXz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbZDQXz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbZDQXzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:55:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbZDQXzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:55:48 -0400
Message-ID: <49E916EF.5040207@zytor.com>
Date: Fri, 17 Apr 2009 16:55:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [14/28] x86: MCE: Add MSR read wrappers for easier error
 injection
References: <20090407507.636692542@firstfloor.org> <20090407150756.23F221D046E@basil.firstfloor.org> <49E866C7.4080707@jp.fujitsu.com> <20090417130030.GK14687@one.firstfloor.org>
In-Reply-To: <20090417130030.GK14687@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> If someone feels strongly about that I can do that, but personally
> I would think using standard function return arguments without
> macros is more regular and more readable in general. That seems
> to be also the general trend in the source base, going away from
> magic macros.
> 
> Do you feel strongly about it?
> 

I would agree with Andi on this; macros or not macros, we should use 
"function-like" style, analogous to rdmsrl() and wrmsrl() in this case.

Inline functions are also preferred over macros, obviously.

	-hpa


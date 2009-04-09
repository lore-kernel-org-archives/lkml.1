Return-Path: <linux-kernel-owner+w=401wt.eu-S1763832AbZDIKLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763832AbZDIKLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761878AbZDIKLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:11:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48171 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764600AbZDIKLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:11:30 -0400
Date: Thu, 9 Apr 2009 12:13:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
Message-ID: <20090409101349.GH14687@one.firstfloor.org>
References: <20090407506.675031434@firstfloor.org> <20090407150656.43E161D046D@basil.firstfloor.org> <49DC5D11.4060505@jp.fujitsu.com> <87eiw3a29h.fsf@basil.nowhere.org> <49DD80B4.5060301@jp.fujitsu.com> <20090409071413.GD14687@one.firstfloor.org> <49DDC70E.2000602@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DDC70E.2000602@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Following is a proposal version. Maybe dividing it into 2 pieces, function
> improvement and MSR definition, would be a good idea.

I don't think we need the full MSR definitions right now, at least 
I don't have any plans to support them. After all current CPUs
don't.

The rest looks good.

-Andi

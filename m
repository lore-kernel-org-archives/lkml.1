Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXLRMFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXLRMFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbXLRMEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:04:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159AbXLRMEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:04:52 -0500
Message-ID: <4767B70F.1050403@redhat.com>
Date: Tue, 18 Dec 2007 10:03:27 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 3/21] [PATCH] move desc_empty to where they belong
References: <11979319641796-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <200712181614.37890.rusty@rustcorp.com.au>
In-Reply-To: <200712181614.37890.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tuesday 18 December 2007 09:52:26 Glauber de Oliveira Costa wrote:
>> +static inline int desc_empty(const void *ptr)
>> +{
>> +	const u32 *desc = ptr;
>> +	return !(desc[0] | desc[1]);
>> +}
> 
> Erk. This really needs to be a union, not a void *.  I guess we can clean it 
> later.
> 
> Rusty.
My last series, that unified desc_struct, made it possible to do that.
However, the intent of this, is just move it to a common place.

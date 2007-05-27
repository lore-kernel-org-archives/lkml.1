Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbXE0AQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbXE0AQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 20:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXE0AQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 20:16:05 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56359 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbXE0AQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 20:16:03 -0400
Message-ID: <4658CDBA.5000603@zytor.com>
Date: Sat, 26 May 2007 17:15:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org>	 <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com>	 <1180174691.650.8.camel@localhost.localdomain>  <4658C72E.9030205@goop.org> <1180224604.29340.4.camel@localhost.localdomain>
In-Reply-To: <1180224604.29340.4.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 
> hpa wrote:
>> Do we have *any* environment that enters the 32-bit code with interrupts
>> enabled?  I would think that is unsafe no matter how you do it.
> 
> Yeah, the cli there seems strange: maybe it's safe to simply delete it?
> 

I suspect it was simply put there as a "belts and suspenders" kind of
thing, which is perfectly appropriate.  However, I would be highly
surprised if it would have any users.

	-hpa

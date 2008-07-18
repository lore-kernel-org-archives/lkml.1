Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYGRPXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYGRPXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYGRPX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:23:27 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:38330 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbYGRPX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:23:26 -0400
Message-Id: <4880D1A0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 16:23:44 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86: clean up pgd_{c,d}tor
References: <4880AD11.76E4.0078.0@novell.com> <4880AE15.5060101@goop.org>
In-Reply-To: <4880AE15.5060101@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 18.07.08 16:52 >>>
>Jan Beulich wrote:
>> Giving pgd_ctor() a properly typed parameter allows eliminating a local
>> variable. Adjust pgd_dtor() to match.
>>
>> Also, pgd_ctor()'s clearing of the memory is redundant with the
>> GFP_ZERO used for allocating it.
>>   
>
>Ack to the parameter type change.  But there's already a patch in git to 
>remove the redundant clear.

Again, I can't see this in my just refreshed tree - am I doing things wrong?
Or is this due to the myriads of topic branches (which of course I don't
check out all)?

Jan


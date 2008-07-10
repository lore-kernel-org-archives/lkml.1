Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbYGJSEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbYGJSEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYGJSEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:04:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYGJSEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:04:40 -0400
Message-ID: <48764DA5.1080503@zytor.com>
Date: Thu, 10 Jul 2008 13:57:57 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org>
In-Reply-To: <m18wwahauq.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>>
>> No, it's not irrelevant; we currently base the kernel at virtual address -2 GB
>> (KERNEL_IMAGE_START) + CONFIG_PHYSICAL_START, in order to have the proper
>> alignment for large pages.
> 
> Ugh.  That is silly.  We need to restrict CONFIG_PHYSICAL_START to the aligned
> choices obviously.  But -2G is better aligned then anything else we can do virtually.
> 

You may think it's silly, but it's actually an advantage in this case.

	-hpa

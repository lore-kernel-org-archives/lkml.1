Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbYGAQ7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbYGAQ7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYGAQ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:59:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbYGAQ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:59:24 -0400
Message-ID: <486A61A7.1000902@zytor.com>
Date: Tue, 01 Jul 2008 09:56:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>	<485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org> <m1skuuov4t.fsf@frodo.ebiederm.org>
In-Reply-To: <m1skuuov4t.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>
>> The zero-based PDA mechanism requires the introduction of a new ELF segment
>> based at vaddr 0 which is sufficiently unusual that it wouldn't surprise me if
>> its triggering some toolchain bug.
> 
> Agreed.  Given the previous description my hunch is that the bug is occurring
> during objcopy.  If vmlinux is good and the compressed kernel is bad.
> 

Actually, it's not all that unusual... it's pretty common in various 
restricted environments.  That being said, it's probably uncommon for 
*64-bit* code.

	-hpa

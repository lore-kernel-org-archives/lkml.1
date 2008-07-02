Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYGBBtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYGBBtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYGBBtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:49:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbYGBBtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:49:01 -0400
Message-ID: <486ADD9F.3000305@zytor.com>
Date: Tue, 01 Jul 2008 18:45:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org>	<485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org>	<485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org> <486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com> <486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>
In-Reply-To: <486ADD67.1020809@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Mike Travis wrote:
> ...  I'm still re-verifying that the source bits and config options 
>> are identical (it was a later git-remote update), and that in fact it is
>> the gcc --version, but that may be the conclusion.  
> ...
> 
> Yup, it's the gcc --version that makes the difference.  GCC 4.2.0 couldn't
> boot past the grub screen, GCC 4.2.4 made it to the login prompt.
> 

IIRC, 4.2.0, 4.2.1 and 4.3.0 are known to miscompile the kernel in one 
way or another, however, that is from memory so don't quote me on it.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbYGBBzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbYGBBzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYGBBzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:55:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43698 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753426AbYGBBzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:55:35 -0400
Message-ID: <486AE015.5070308@sgi.com>
Date: Tue, 01 Jul 2008 18:55:33 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org>	<485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org>	<485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org> <486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com> <486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com> <486ADD9F.3000305@zytor.com>
In-Reply-To: <486ADD9F.3000305@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mike Travis wrote:
>> Mike Travis wrote:
>> ...  I'm still re-verifying that the source bits and config options
>>> are identical (it was a later git-remote update), and that in fact it is
>>> the gcc --version, but that may be the conclusion.  
>> ...
>>
>> Yup, it's the gcc --version that makes the difference.  GCC 4.2.0
>> couldn't
>> boot past the grub screen, GCC 4.2.4 made it to the login prompt.
>>
> 
> IIRC, 4.2.0, 4.2.1 and 4.3.0 are known to miscompile the kernel in one
> way or another, however, that is from memory so don't quote me on it.
> 
>     -hpa

Great.  That's what's been on my devel server for the past 3 or 4 months now... 

[And it's a big shared server that I'm but a small ant wandering around on it. ;-)]

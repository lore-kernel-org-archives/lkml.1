Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYJOG3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYJOG3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 02:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYJOG2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 02:28:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:34907 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbYJOG2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 02:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JS2sCZzZ4uTqiFvk4mxnpeagOcgBQje+X8U/Fx9rnG2u3+w5K3RbEr0d3cFnmk7YXs
         EtjgWb9WsfajXVCNwZRVhp9KhI3NcrKGCn0q1sfoPGDqdAHw0FLU+ETgC0qB6IaJZh4l
         87diXU1higMRx+bmBQcngKuGSLpzkTPQaPQyE=
Message-ID: <aec7e5c30810142328n1563163bw636b8baf1a47ad8b@mail.gmail.com>
Date: Wed, 15 Oct 2008 15:28:51 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] soc-camera: fix compile breakage on SH
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       "Stefan Herbrechtsmeier" <hbmeier@hni.uni-paderborn.de>,
       "Mauro Carvalho Chehab" <mchehab@redhat.com>, lethal@linux-sh.org,
       linux-sh@vger.kernel.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, "Magnus Damm" <damm@igel.co.jp>
In-Reply-To: <20081015052026.GC20183@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081014183936.GB4710@cs181140183.pp.htv.fi>
	 <Pine.LNX.4.64.0810142335400.10458@axis700.grange>
	 <20081015033303.GC4710@cs181140183.pp.htv.fi>
	 <20081015052026.GC20183@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 2:20 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Wed, Oct 15, 2008 at 06:33:03AM +0300, Adrian Bunk wrote:
>> On Tue, Oct 14, 2008 at 11:53:37PM +0200, Guennadi Liakhovetski wrote:
>> > Fix Migo-R compile breakage caused by incomplete merge.
>> >
>> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> >
>> > ---
>> >
>> > Hi Adrian,
>>
>> Hi Guennadi,
>>
>> > please see, if the patch below fixes it. Completely untested. Magnus,
>> > could you please verify if it also works (of course, if it at least
>> > compiles:-)) If it doesn't, please fix it along these lines, if it suits
>> > your needs.
>> >...
>>
>> it does compile.
>>...
>
> But it causes compile breakage elsewhere:
>
> <--  snip  -->

Hi guys,

Thanks for working on fixing the breakage. I'd prefer to wait a bit
since there are quite a few pinmux patches queued up that may break if
we merge a fix right now. I can fix it up later on.

Thanks,

/ magnus

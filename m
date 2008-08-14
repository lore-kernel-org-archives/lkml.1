Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbYHNTCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbYHNTCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759810AbYHNTB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:01:59 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:12230 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759641AbYHNTB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WGB2NC7ml60ayGmVBTe/DkeJ48SjgM3+unQ5HYUwUKKOxBo3u8q155lq584URe2Ayk
         b/Bn+zE4ub0igW67200UKPR5bS69OX5ZU8LIvQRD+J+6+FybfnzhjYmapyEoYllNCOg+
         yBqnunFJVsDjVB2Oc365F9JyzB1qezRO2kFls=
Message-ID: <48f7fe350808141201y24669c8foee0bea867fe612b3@mail.gmail.com>
Date: Thu, 14 Aug 2008 15:01:56 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: Help writing kernel module...
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080814180207.GC12476@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808141100h3f368a53kb371e4cefea3e70@mail.gmail.com>
	 <20080814180207.GC12476@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

what about if I want to determine if a module is loaded?

On Thu, Aug 14, 2008 at 2:02 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Thu, Aug 14, 2008 at 02:00:26PM -0400, Ryan Hope wrote:
>> I can't find any information on how to make a kernel module load
>> another module. Can someone please tell me how to do this? Thanks in
>> advance.
>
> Use a symbol exported by that other module and your module should
> automatically depend on that module and modprobe will nicely load it
> before your module for you.
>
> --
> Len Sorensen
>

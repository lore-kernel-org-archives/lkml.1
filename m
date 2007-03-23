Return-Path: <linux-kernel-owner+w=401wt.eu-S1422811AbXCWLZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422811AbXCWLZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 07:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422809AbXCWLZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 07:25:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:50648 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422811AbXCWLZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 07:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=SLZNpFhE+AgZMSFkh6zim4l/yZ8dTIu+ScMfZ6tgtBfNyeeko4hl1iZhNxxjxpsmr3aDpVki27DRWJC2+UgwnF4Komy9NulruZUilYw7ynufGexMh1L+lOnb9GdZo15c2TF7jBDUSEGu3ZdcXOpOtrTy765e92RwBF97iOtMTRs=
Message-ID: <4603B937.9080008@gmail.com>
Date: Fri, 23 Mar 2007 14:25:43 +0300
From: Sergey Smirnov <svs1957@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: HELP!!! SD and suspend damage i-node.
References: <4602781C.9060804@gmail.com> <200703222255.20167.rjw@sisk.pl>
In-Reply-To: <200703222255.20167.rjw@sisk.pl>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's happen only with 4G SD. I made the same test in 512Mb SD.
After suspend/resume there is no errors on fs.

If I resume PDA with 4G SD it go back to suspend after few seconds.

Rafael J. Wysocki wrote:
> On Thursday, 22 March 2007 13:35, Sergey Smirnov wrote:
>> I use 2.6.20.2 kernel with ext3 rootfs on 4Gb SD on sharp zaurus sl-750 (PXA255).
>> After suspend/resume filesystem stay clean. But some i-nodes become broken.
>> Some files looks like block device or pipe with strange permissions, owner etc.
>> I'm sure that there is no bad blocks on SD.
>> I'll send any additional information. Just say me what you need to help me.
>> I had i lot of tries. Apply patches, remove its, change fstype etc.
>> output of fsck -f
> 
> I assume this is the suspend to RAM?
> 
> Rafael
> 


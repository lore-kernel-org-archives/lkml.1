Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYH2IIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYH2IIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYH2IIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:08:38 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:21300 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYH2IIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q8855DG6xX2XKrDPng3VwBvVJowt3BFBOjEYehDjiigxIDy7APuJkvZdHBQw7CkPMY
         E2zIBOg/VhdfbOuxuUwLv7LJ7bl8lekYjPHs1LJpIx+tbphN6dHrvdnJ3bKnHmhv2G7+
         txfewdcE65+SeVZHGTMXDAoLowj8l2YfAk/8w=
Message-ID: <86802c440808290108m170d74b3t6838f96e2d8d6959@mail.gmail.com>
Date: Fri, 29 Aug 2008 01:08:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jari Aalto" <jari.aalto@cante.net>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87vdxkb6rs.fsf@jondo.cante.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B76FF5.6010507@yahoo.com.ar> <87vdxkb6rs.fsf@jondo.cante.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 12:49 AM, Jari Aalto <jari.aalto@cante.net> wrote:
>> On Thu, Aug 28, 2008 at 1:49 PM, Jari Aalto <jari.aalto@cante.net> wrote:
>>
>>> Krzysztof Halasa <khc@pm.waw.pl> writes:
>>>
>>>> Jari Aalto <jari.aalto@cante.net> writes:
>>>>
>>>>> What, if after booting to 2.6.26 and without any 'iommu' boot parameters,
>>>>> there still appears "Out of Iommu space" messages? What kind of logs
>>>>> should I post?
>>>>
>>>> You shouldn't be getting "Out of SW-IOMMU space" messages when not
>>>> using SW-IOMMU.
>>>
>>> REF: http://article.gmane.org/gmane.linux.kernel/725293 (thread start)
>>>
>>> I regret to report that:
>>>
>>> - Upgraded to kernel 2.6.26-1-amd64 (Debian/unstable 2.6.26-3)
>>
>> can you send out whole boot log? with "debug initcall_debug"
>
> See below.
>
>> http://people.redhat.com/mingo/tip.git/readme.txt
>
> Could you explain this document a bit. What git commands should I use to
> retrive test kernel to build?


mkdir linux.trees.git || exit -1
cd linux.trees.git

git init
git remote add linus
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

git remote add tip
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

git remote update

git checkout -b tip-latest tip/master

can you fix your mail client? it stripped Cc and automatically?

YH

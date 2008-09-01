Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbYIANdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbYIANdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYIANd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:33:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:15603 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYIANd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W1M9ENziU0yMV1LND7h4vch0D5Dkgcj7TfgUCHSF0jxigRHtA20lsuiRwGfSpOItdv
         6mcu83Mta4X4DxK46oFBueD+SHL5pdPIDCw3g7hW8y56bpZWk97iB1vcfzDdwPgygWQs
         kuzjDrVKCxzg9dSATimYqRIlmRI+ZJnF7vbKg=
Message-ID: <5ff4a1e50809010633q6d69bcabtac734d2d8e2c6d88@mail.gmail.com>
Date: Mon, 1 Sep 2008 14:33:27 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: ktime_set() does not check for nanoseconds > one second
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0809011515060.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5ff4a1e50809010338o77fffec4w625ed48b3987d51@mail.gmail.com>
	 <alpine.LFD.1.10.0809011317460.3243@apollo.tec.linutronix.de>
	 <5ff4a1e50809010457l7051b7e8vc7f86d68ae42e529@mail.gmail.com>
	 <alpine.LFD.1.10.0809011501450.3243@apollo.tec.linutronix.de>
	 <5ff4a1e50809010611x3d8940e0n282da0b1ec5b321b@mail.gmail.com>
	 <alpine.LFD.1.10.0809011515060.3243@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/1 Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 1 Sep 2008, Matt Fleming wrote:
>
>> 2008/9/1 Thomas Gleixner <tglx@linutronix.de>:
>> >
>> > Won't work with arbitrary numbers. i.e. >= 2* NSEC_PER_SEC. Looking at
>> > it, I'm even less convinced that it is a good idea.
>> >
>> >      tglx
>> >
>>
>> Do you have another suggestion? Or should I just account for the >= 1
>> sec case in the calling code?
>
> If you use runtime generated nsec values, why don't you use
> ktime_add_ns() and feed the nsec value into it ?
>

Hmm.. good point. I'll do it that way. Thanks for your help Thomas.

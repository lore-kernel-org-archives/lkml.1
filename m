Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbXEMVYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbXEMVYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbXEMVYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:24:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39094 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbXEMVYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:24:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	<m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
	<86802c440705122329y27c6ef92v8cff43d52b99ae69@mail.gmail.com>
	<m1abw9qkve.fsf@ebiederm.dsl.xmission.com>
	<86802c440705122355r5f811d5bg2006b0b22ca885e6@mail.gmail.com>
	<m11whlqk1g.fsf@ebiederm.dsl.xmission.com>
	<86802c440705130027vce147dma85a07de6489d666@mail.gmail.com>
	<86802c440705131101r5b32e0b9j28e2248813b25b64@mail.gmail.com>
	<m1646wpkr5.fsf@ebiederm.dsl.xmission.com>
	<86802c440705131406u36340ad4tbc4d81c7df2356bf@mail.gmail.com>
Date: Sun, 13 May 2007 15:23:43 -0600
In-Reply-To: <86802c440705131406u36340ad4tbc4d81c7df2356bf@mail.gmail.com>
	(Yinghai Lu's message of "Sun, 13 May 2007 14:06:33 -0700")
Message-ID: <m1wszco1sw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On 5/13/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> We have big boot protocol revision coming up to more clearly document
>> what is needed to work with the native entry points.  It is a 2.6.23
>> targeted thing and that is one of the things that we are likely to
>> look at.
>
> Good, where is the thread for that?

Look on the virtualization list may lkml was cc'd about getting
Xen and lguest.  "boot bzImages under paravirt"  I think was
the subject on one of the pieces.

A lot of this work is held up in part by the need to get 2.6.22
out, and in part because we have so much in flight work for the
early phases of boot that we need to let things settle
before it we can do more.

Eric

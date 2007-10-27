Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbXJ0HrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbXJ0HrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 03:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXJ0HrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 03:47:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60280 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXJ0HrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 03:47:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Salyzyn, Mark" <mark_salyzyn@adaptec.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 7/9] irq-remove: scsi driver trivial
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075808.GH6407@havoc.gtf.org>
	<AE4F746F2AECFC4DA4AADD66A1DFEF01F3D54D@otce2k301.adaptec.com>
	<20071026143525.b9218ed7.akpm@linux-foundation.org>
	<4722608E.3000405@garzik.org>
	<20071026165035.33383e36@laptopd505.fenrus.org>
	<47228278.8070505@garzik.org>
	<20071026171606.4e242f49@laptopd505.fenrus.org>
	<4722885B.7050307@garzik.org>
	<20071026223137.5e311481@laptopd505.fenrus.org>
	<4722E360.7000305@garzik.org>
Date: Sat, 27 Oct 2007 01:46:15 -0600
In-Reply-To: <4722E360.7000305@garzik.org> (Jeff Garzik's message of "Sat, 27
	Oct 2007 03:06:08 -0400")
Message-ID: <m1lk9proe0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Arjan van de Ven wrote:
>> On Fri, 26 Oct 2007 20:37:47 -0400
>> Jeff Garzik <jeff@garzik.org> wrote:
>>
>>> Arjan van de Ven wrote:
>>>> the other serious question is.. how is IRQ_HANDLER_V3 different
>>>> from a #ifdef VERSION >= 2.6.24 .....
>>>> it's not really ;)
>>> Note my mention of backport -- kernel version isn't relevant when the various
>>> enterprise distros have random featuresets under random
>>> kernel versions.
>>>
>>
>> yeah and THEY can put the defines in (RH used to do this fwiw as a
>> generic "this is a RH kernel" define)....
>>
>> but afaik no distro vendor backports such an api change nowadays... and
>> hasn't in 2.6 ever
>
> People backport drivers all the time that must support a wide range of kernels.

I thought the argument was not that drivers are back ported but that
internal kernel APIs changes aren't backported.  So that testing
the kernel version actually has a chance as a reasonable test for
features.

Eric

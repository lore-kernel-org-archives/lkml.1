Return-Path: <linux-kernel-owner+w=401wt.eu-S1761669AbXFBBTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761669AbXFBBTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbXFBBSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:18:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35741 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbXFBBSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:18:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org>
	<m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <466087CF.70708@goop.org>
	<4660924A.2070009@zytor.com> <466093E3.4010701@goop.org>
	<46609636.4050208@zytor.com> <4660BBDF.1040007@goop.org>
	<4660BCF8.7000208@zytor.com> <4660C0CD.5060606@goop.org>
	<4660C194.4010003@zytor.com> <4660C2F6.6070005@goop.org>
Date: Fri, 01 Jun 2007 19:17:48 -0600
In-Reply-To: <4660C2F6.6070005@goop.org> (Jeremy Fitzhardinge's message of
	"Fri, 01 Jun 2007 18:08:06 -0700")
Message-ID: <m1odjzxigz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> H. Peter Anvin wrote:
>> It would have to, because of the way code32_start is defined to work.
>> We don't get control again after its use as a hook.
>>   
>
> Who uses that hook?  The impression I get is that the execution
> environment for jumping to that pointer is not very well defined at present.

loadlin.

Eric

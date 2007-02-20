Return-Path: <linux-kernel-owner+w=401wt.eu-S932635AbXBTRgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbXBTRgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbXBTRgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:36:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35646 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbXBTRgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:36:02 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Paul Menage" <menage@google.com>
Cc: "Sam Vilain" <sam@vilain.net>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
References: <20070212081521.808338000@menage.corp.google.com>
	<45D0EC68.9090009@vilain.net>
	<6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
Date: Tue, 20 Feb 2007 10:34:00 -0700
In-Reply-To: <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
	(Paul Menage's message of "Mon, 12 Feb 2007 15:15:51 -0800")
Message-ID: <m1wt2c4ttj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul Menage" <menage@google.com> writes:

> On 2/12/07, Sam Vilain <sam@vilain.net> wrote:
>>
>> I know I'm a bit out of touch, but AIUI the NSProxy *is* the container.
>> We decided a long time ago that a container was basically just a set of
>> namespaces, which includes all of the subsystems you mention.
>
> You may have done that, but the CKRM/ResGroups independently decided a
> long time ago that the fundamental unit was the resource class, and
> the OpenVZ folks decided that the fundamental unit was the
> BeanCounter, and the CPUSet folks decided that the fundamental unit
> was the CPUSet, etc ... :-)

Using the container name is bad and it led to this stupid argument.

The fundamental unit of what we have merged into the kernel is the
namespace.  The aggregate of all namespaces and everything is the
container.

Please, please pick a different name so people don't take one look
at your stuff and get confused like Sam did.

> But there's a lot of common ground between these different approaches,
> and potential for synergy, so the point of this patch set is to
> provide a unification point for all of them, and a stepping stone for
> other new resource controllers and process control modules.

For the case of namespaces I don't see how your code makes things
better.  I do not see a real problem that you are solving.

I do agree that a common interface to the code and a common set of
infrastructure may help.

Personally until the pid namespace (which includes within it process
groupings) is complete I'm not certain the problem will be concrete
enough to solve.  Hopefully we can have a working version of that
shortly.

Eric

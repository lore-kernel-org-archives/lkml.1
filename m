Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZGBPoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZGBPoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZGBPoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:44:01 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52229 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbZGBPoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:44:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=E9vcVct5OeDgOEi5UaOkyv+g4VfcCwe0/4CJlTA/b64GjLYseTGTFalUWLJII9GrY
	Muegw0jn5u+MpJYkv7nfA==
MIME-Version: 1.0
In-Reply-To: <20090702132659.GA8051@us.ibm.com>
References: <4A4C0C60.4050106@cn.fujitsu.com>
	 <6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com>
	 <4A4C18D5.7020806@cn.fujitsu.com>
	 <6599ad830907011920r44df4022p53808b574da4a886@mail.gmail.com>
	 <4A4C1B33.2030002@cn.fujitsu.com> <20090702132659.GA8051@us.ibm.com>
Date: Thu, 2 Jul 2009 08:43:57 -0700
Message-ID: <6599ad830907020843l7ce75abfq3e78b8f67a407ab9@mail.gmail.com>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
From: Paul Menage <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 6:26 AM, Serge E. Hallyn<serue@us.ibm.com> wrote:
> Quoting Li Zefan (lizf@cn.fujitsu.com):
>> Paul Menage wrote:
>> > On Wed, Jul 1, 2009 at 7:17 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> >> But I guess we are going to fix the bug for 2.6.31? So is it ok to
>> >> merge a new feature 'cgroup.procs' together into 2.6.31?
>> >>
>> >
>> > Does this bug really need to be fixed for 2.6.31? I didn't think that
>> > the namespace support in mainline was robust enough yet for people to
>> > use them for virtual servers in production environments.
>
> I don't know where the bar is for 'production environments', but I'd
> have to claim that pid namespaces are there...

Well, pid namespaces are marked as experimental, as are user
namespaces (and were described as "very incomplete" a few months
back). Pid namespaces are useful for process migration (which is still
under development) or virtual servers (for which user namespaces are
pretty much essential). So I'm not sure quite what you'd use pid
namespaces for yet.

Paul

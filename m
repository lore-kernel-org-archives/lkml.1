Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZGBQ12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZGBQ12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZGBQ1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:27:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:2112 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZGBQ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:27:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=HvEvNAGC6E9m2XfKD1xq8aTw/eTPDkyRPK3AoySPOdGLYhSz6DuraO+JniYStQFJx
	PHyc1rrlcR5dCMa4nHEMA==
MIME-Version: 1.0
In-Reply-To: <20090702161548.GA13383@us.ibm.com>
References: <4A4C0C60.4050106@cn.fujitsu.com>
	 <6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com>
	 <4A4C18D5.7020806@cn.fujitsu.com>
	 <6599ad830907011920r44df4022p53808b574da4a886@mail.gmail.com>
	 <4A4C1B33.2030002@cn.fujitsu.com> <20090702132659.GA8051@us.ibm.com>
	 <6599ad830907020843l7ce75abfq3e78b8f67a407ab9@mail.gmail.com>
	 <20090702161548.GA13383@us.ibm.com>
Date: Thu, 2 Jul 2009 09:27:20 -0700
Message-ID: <6599ad830907020927x44a88a6dgb229fb2ad6ef5481@mail.gmail.com>
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

On Thu, Jul 2, 2009 at 9:15 AM, Serge E. Hallyn<serue@us.ibm.com> wrote:
>>
>> Well, pid namespaces are marked as experimental, as are user
>> namespaces (and were described as "very incomplete" a few months
>
> incomplete (due to signaling issues which have mostly been resolved)
> but stable and usable.
>
> user namespace are a completely different story :)

Sorry, that wasn't clear - the "very incomplete" referred to user namespaces.

Paul

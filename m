Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZGBX3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZGBX3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZGBX3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:29:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZGBX3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:29:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=KcmMGKlZFjW5hM4xzRR5nFW8kyviNBkDHKvZ+vKXDpTOEEvqYE6Cpam8BbA1nQsFo
	ZELeAkAZlcj1ulewA3YWg==
MIME-Version: 1.0
In-Reply-To: <20090702162019.f34f12d6.akpm@linux-foundation.org>
References: <4A4C0C60.4050106@cn.fujitsu.com>
	 <6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com>
	 <4A4C18D5.7020806@cn.fujitsu.com>
	 <6599ad830907011920r44df4022p53808b574da4a886@mail.gmail.com>
	 <4A4C1B33.2030002@cn.fujitsu.com> <20090702132659.GA8051@us.ibm.com>
	 <6599ad830907020843l7ce75abfq3e78b8f67a407ab9@mail.gmail.com>
	 <20090702161548.GA13383@us.ibm.com>
	 <6599ad830907020927x44a88a6dgb229fb2ad6ef5481@mail.gmail.com>
	 <20090702162019.f34f12d6.akpm@linux-foundation.org>
Date: Thu, 2 Jul 2009 16:29:00 -0700
Message-ID: <6599ad830907021629q777d6574me3f37e0ee797f95a@mail.gmail.com>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: serue@us.ibm.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 4:20 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>
> I do think we should lean toward fixing it.  After all, it used to work
> OK and now it doesn't.
>
> It is a three-minute matter of patch-wrangling to take the fix out
> again within a more comprehensive 2.6.32 patch series, so that's not an
> issue.
>
> So are there any strong (enough) objections to putting this into 2.6.31?
>

I guess no strong objection on the principle, but the patch as it
stands is missing a couple of pid_ns refcount operations in order to
be a complete fix (IMO).

Paul

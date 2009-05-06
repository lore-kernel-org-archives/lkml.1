Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbZEFSqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbZEFSqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZEFSq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:46:28 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47907 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZEFSq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:46:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=q8oC4wIOhKToS6RK0kv7SFiCUWBJ/mj+/cHDBwGiQEto6ZvkY/1yVDbZQpioTAg2f
	pN1fZvu/fvUXnDGKYwkvA==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0902280916470.3111@localhost.localdomain>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
	 <20090228030413.5B915FC3DA@magilla.sf.frob.com>
	 <alpine.LFD.2.00.0902271932520.3111@localhost.localdomain>
	 <alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
	 <20090228072554.CFEA6FC3DA@magilla.sf.frob.com>
	 <alpine.LFD.2.00.0902280916470.3111@localhost.localdomain>
Date: Wed, 6 May 2009 11:46:24 -0700
Message-ID: <904b25810905061146ged374f2se0afd24e9e3c1f06@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
From: =?UTF-8?B?TWFya3VzIEd1dHNjaGtlICjpoaflrZ/li6Qp?= 
	<markus@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 10:23, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> And I guess the seccomp interaction means that this is potentially a
> 2.6.29 thing. Not that I know whether anybody actually _uses_ seccomp. It
> does seem to be enabled in at least Fedora kernels, but it might not be
> used anywhere.

In the Linux version of Google Chrome, we are currently working on
code that will use seccomp for parts of our sandboxing solution.


Markus

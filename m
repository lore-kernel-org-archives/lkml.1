Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbYBGRjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbYBGRjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760225AbYBGRiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:38:46 -0500
Received: from smtp-out.google.com ([216.239.33.17]:14144 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbYBGRio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:38:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=Qpm5DQ4eMhN5QMsqYFdmaT6Jak1bJmPQ4STAseENXiPDKXlVAi+S0vUe3RHpzmNoL
	mBDRGmtobol0akv+7FsaA==
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
From: Frank Mayhar <fmayhar@google.com>
To: parag.warudkar@gmail.com
Cc: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
In-Reply-To: <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080206165045.89b809cc.akpm@linux-foundation.org>
	 <1202345893.8525.33.camel@peace.smo.corp.google.com>
	 <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	 <20080207162203.3e3cf5ab@Varda>
	 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
Content-Type: text/plain; charset=ISO-8859-1
Organization: Google, Inc.
Date: Thu, 07 Feb 2008 09:36:49 -0800
Message-Id: <1202405809.31679.3.camel@peace.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-07 at 10:53 -0500, Parag Warudkar wrote:
> 
> On Thu, 7 Feb 2008, Alejandro Riveira Fernández wrote:
> 
> > gcc --version
> > 
> > gcc-4.2 (GCC) 4.2.1 (Ubuntu 4.2.1-5ubuntu4)
> >  
> > If some fields are empty or look unusual you may have an old version.
> > Compare to the current minimal requirements in Documentation/Changes.
> >  
> > Linux Varda 2.6.24 #2 SMP PREEMPT Fri Jan 25 01:05:47 CET 2008 x86_64 GNU/Linux
> >
> So x86+SMP+GnuC-4.1.2+Glibc-2.5 = Not reproducible.
> 
>    x86_64+SMP+PREEMPT+GnuC-4.1.2+Glibc-2.5 = Reproducible.	
> 
> Not sure what the original reporter's $ARCH was.

Several, among which were i686+SMP+GnuC-4.0.3+Glibc-2.3.6.  No PREEMPT.
Linux 2.6.18, 2.6.21 and 2.6.24-rc4.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbZHHBvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbZHHBvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 21:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZHHBvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 21:51:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45502 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZHHBvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 21:51:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=rNFmW3uyDTAzBGrvxfpFnBN669Vpj0oeHJ4FFqc36ZyZtvQC5l8g6vqWdGWozGymT
	YYOzBRN8yo5qsTsMytUIA==
MIME-Version: 1.0
In-Reply-To: <2f86c2480908071841h13009856hd8fcae167b1fadbf@mail.gmail.com>
References: <20090803194555.GA10158@us.ibm.com>
	 <20090805102057.GT29252@hawkmoon.kerlabs.com>
	 <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
	 <20090805164218.GB26446@hawkmoon.kerlabs.com>
	 <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
	 <20090806095854.GD26446@hawkmoon.kerlabs.com>
	 <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
	 <20090806112450.GF26446@hawkmoon.kerlabs.com>
	 <6599ad830908060440g2f6cbed6xdc54c7096cd3745e@mail.gmail.com>
	 <2f86c2480908071841h13009856hd8fcae167b1fadbf@mail.gmail.com>
Date: Fri, 7 Aug 2009 18:51:28 -0700
Message-ID: <2f86c2480908071851t1de88762n7f6b9a44e00fc42f@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Benjamin Blum <bblum@google.com>
To: Paul Menage <menage@google.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 7, 2009 at 6:41 PM, Benjamin Blum<bblum@google.com> wrote:
> For genericness, I'll have the down_read and up_read on the lock in
> do_fork() directly (instead of cgroup_fork and cgroup_post_fork as it
> is in this version of the patch).

rather, I'll keep the read-locking in the cgroup functions for now and
any future thing that wants the lock too can move them to fork.c, and
a comment to that effect.

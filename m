Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYI2SCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYI2SCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYI2SCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:02:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61344 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYI2SCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=yj6UZEcOj/h7lPVUEll3YVopfbcZ/c1jKYAqoMJ9MbDzBgonv9cwXHt2v1JV+cC9x
	w9sfru1/Y91xW2PADsTMQ==
Message-ID: <af8810200809291102w452de643u5902dc216cafe3eb@mail.gmail.com>
Date: Mon, 29 Sep 2008 11:02:23 -0700
From: Pardo <pardo@google.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Faster getcpu() and sched_getcpu()
Cc: "dean gaudet" <odo@google.com>, linux-kernel@vger.kernel.org,
       mbligh@google.com, briangrant@google.com, nil@google.com,
       jyasskin@google.com
In-Reply-To: <20080929145408.GQ25711@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <af8810200809111648n55e05ac9g286fcd498690432f@mail.gmail.com>
	 <af8810200809231209w7428347neb88094e543a048f@mail.gmail.com>
	 <87wsgwp6gh.fsf@basil.nowhere.org> <48E0834D.6010608@google.com>
	 <20080929145408.GQ25711@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>[Maybe disable frame pointers for vsyscall.c and the vdso?]

IIRC, some vsyscall.c code needs them enabled, so Dean's earlier patch
split vsyscall.c, creating a vsyscall_user.c for code which can run
without them.  Seem reasonable?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbXEKTzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbXEKTzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031230AbXEKTsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:48:30 -0400
Received: from gw.goop.org ([64.81.55.164]:55587 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031210AbXEKTs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:48:28 -0400
Message-ID: <4644C887.8040101@goop.org>
Date: Fri, 11 May 2007 12:48:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [patch 2/7] use elfnote.h to generate vsyscall notes.
References: <20070511194725.E37E51F8512@magilla.localdomain>
In-Reply-To: <20070511194725.E37E51F8512@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> I used .balign because .align has inconsistent meaning on some platforms
> (matches .p2align instead of .balign).  Using .align in a
> machine-independent file seems questionable.
>   

OK, good point.

    J

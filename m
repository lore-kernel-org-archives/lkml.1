Return-Path: <linux-kernel-owner+w=401wt.eu-S1161537AbXD1H3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161537AbXD1H3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965496AbXD1H3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:29:48 -0400
Received: from gw.goop.org ([64.81.55.164]:50794 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965461AbXD1H3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:29:47 -0400
Message-ID: <4632F7EE.6080101@goop.org>
Date: Sat, 28 Apr 2007 00:29:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use elfnote.h to generate vsyscall notes
References: <20070428071615.242FC1801A4@magilla.sf.frob.com>
In-Reply-To: <20070428071615.242FC1801A4@magilla.sf.frob.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> Please don't change the section name that way. 

Does the section name matter? I've been operating under the assumption
that it doesn't, other that needing to start with .note. Using
.note.vendor means that all the vendor's notes will get grouped
properly, but other than that it seems much of a muchness.

>  I don't see why the macros
> should do differently than what was in vsyscall-note.S to begin with.
>   
Well, passing the section name seems redundant unless its actually
needed. In this case it will go from .note.kernel-version to
.note.Linux, but it will end up being called .note in the final vdso
regardless.

J

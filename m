Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYIVBak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYIVBak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 21:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYIVBad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 21:30:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbYIVBac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 21:30:32 -0400
Date: Sun, 21 Sep 2008 21:28:41 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] [RFC] tracehook: Hook in syscall tracing markers.
Message-ID: <20080922012841.GA6199@redhat.com>
References: <20080921021630.GA6443@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921021630.GA6443@linux-sh.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> At kernel summit, the idea that syscall tracing was generally desirable
> for tracing was mentioned several times, as was the argument that kernel
> developers aren't placing markers in meaningful locations. This is a
> simple patch to try and do that for the syscall case.[...]

One problem with this is that a separate mechanism would be needed to
activate these tracehook_report_* calls in the first place: the
management of the per-task TIF_SYSCALL_TRACE flag.  This is one of the
things the utrace API makes straightforward, in which case its own
native syscall reporting callbacks can be used directly.

- FChE

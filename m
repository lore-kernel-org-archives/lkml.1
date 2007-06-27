Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbXF0TXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbXF0TXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXF0TXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:23:01 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3014 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXF0TXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:23:00 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 27 Jun 2007 12:22:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Rik van Riel <riel@redhat.com>
cc: Ulrich Drepper <drepper@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <4682B3B0.2040500@redhat.com>
Message-ID: <Pine.LNX.4.64.0706271218280.5219@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2> 
 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com> 
 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com> 
 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com> 
 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
 <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
 <4682B3B0.2040500@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Rik van Riel wrote:

> Ulrich Drepper wrote:
> > On 6/27/07, Hugh Dickins <hugh@veritas.com> wrote:
> > > Not so: if an mmap can be done by extending either adjacent vma (prot
> > > and flags and file and offset all match up), that's what's done and no
> > > separate vma is created.  (And adjacent vmas get merged when mprotect
> > > removes the difference in protection.)
> > 
> > mmap return values are randomized.  If they would be mergable
> > something would be wrong.
> 
> You can easily pass a hint address to mmap(), causing it to
> extend a malloc arena instead of creating a new VMA.

You mean something like the F_DUPFD, where you pass an fd and that serves 
as from-there-up hint?



- Davide



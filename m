Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbYEIMar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbYEIMar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbYEIMai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:30:38 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:47918 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbYEIMah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:30:37 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200805091229.m49CTMJW001947@clem.clem-digital.net>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
To: rene.herman@keyaccess.nl (Rene Herman)
Date: Fri, 9 May 2008 08:29:22 -0400 (EDT)
Cc: tiwai@suse.de (Takashi Iwai), gcosta@redhat.com (Glauber Costa),
       mingo@elte.hu (Ingo Molnar), tglx@linutronix.de (Thomas Gleixner),
       clem@clem.clem-digital.net (Pete Clements),
       linux-kernel@vger.kernel.org (Linux Kernel),
       alsa-devel@alsa-project.org (ALSA devel)
In-Reply-To: <48243D86.7020504@keyaccess.nl>
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rene Herman
  > On 09-05-08 08:06, Takashi Iwai wrote:
  > 
  > > Thanks for catching it.  Yeah, the patch looks buggy.  We had an
  > > implicit assumption that dev = NULL for ISA devices that require 24bit
  > > DMA.
  > > 
  > > How about the patch below?  It's against the latest Linus git tree.
  > 
  > Yes, works well. Thank you.
  > 
  > Rene.
  > 
Confirmed here also with git7. Thanks

-- 
Pete Clements 

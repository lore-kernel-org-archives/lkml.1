Return-Path: <linux-kernel-owner+w=401wt.eu-S935804AbYEBPrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935804AbYEBPrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934381AbYEBPrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:47:33 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:19587 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbYEBPrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:47:32 -0400
To: Fabio De Francesco <fabiomdf@alice.it>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [x86_32] With 4GB installed, in which cases low mem total is less than 896MB?
From: Andi Kleen <andi@firstfloor.org>
References: <200804301702.06019.fabiomdf@alice.it>
	<20080429101852.6719eb59@infradead.org>
	<200805021638.52540.fabiomdf@alice.it>
Date: Fri, 02 May 2008 17:47:17 +0200
In-Reply-To: <200805021638.52540.fabiomdf@alice.it> (Fabio De Francesco's message of "Fri, 2 May 2008 16:38:46 +0200")
Message-ID: <87skx0vhbu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 15:40:23.0199 (UTC) FILETIME=[D5B52AF0:01C8AC6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio De Francesco <fabiomdf@alice.it> writes:
>
> Unfortunetally my poor knowledge of Linux kernel mechanisms (and
> code!) prevents me from understanding what could be the causes for
> that overhead. Do you mean it is a hardware issue? Or is it a kernel
> one? Anyway another machine of mine, that is equipped with 2GB RAM,
> doesn't show any proportional reduction of low memory at all. So
> this makes me think (oh, dear!).

You might want to read http://halobates.de/memorywaste.pdf, in
particular 3.5.2. The numbers arjan quoted and in the paper
are for 64bit kernels, on 32bit the overhead is ~32bytes/page. This
mem_map overhead happens for both highmem and lowmem, but is always
allocated in lowmem.

-Andi

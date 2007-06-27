Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbXF0TA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbXF0TA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXF0TAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:00:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbXF0TAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:00:17 -0400
Message-ID: <4682B3B0.2040500@redhat.com>
Date: Wed, 27 Jun 2007 15:00:00 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Hugh Dickins <hugh@veritas.com>, Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>	 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com>	 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>	 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>	 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com> <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
In-Reply-To: <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 6/27/07, Hugh Dickins <hugh@veritas.com> wrote:
>> Not so: if an mmap can be done by extending either adjacent vma (prot
>> and flags and file and offset all match up), that's what's done and no
>> separate vma is created.  (And adjacent vmas get merged when mprotect
>> removes the difference in protection.)
> 
> mmap return values are randomized.  If they would be mergable
> something would be wrong.

You can easily pass a hint address to mmap(), causing it to
extend a malloc arena instead of creating a new VMA.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.

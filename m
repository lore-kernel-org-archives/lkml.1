Return-Path: <linux-kernel-owner+w=401wt.eu-S1767658AbXDFOFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767658AbXDFOFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 10:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767659AbXDFOFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 10:05:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:27595 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767658AbXDFOFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 10:05:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,382,1170662400"; 
   d="scan'208"; a="69689440:sNHT18968130"
Message-ID: <4616537D.20702@linux.intel.com>
Date: Fri, 06 Apr 2007 07:04:45 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@sw.ru>
CC: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Lockdep VS rw-semaphores strangeness
References: <46161D84.9030706@sw.ru>
In-Reply-To: <46161D84.9030706@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> I've already caught a fake warning when trying to write-lock
> an mm->mmap_sem with another mm's mmap_sem write-locked. With the
> patch attached everything works, fine.
> 
btw why is that a fake warning? what is your guarantee that you never 
ever do it in the opposite direction from the other thread as well?

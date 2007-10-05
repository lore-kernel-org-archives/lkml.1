Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbXJEAKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbXJEAKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 20:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757930AbXJEAKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 20:10:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbXJEAKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 20:10:37 -0400
Message-ID: <470580F7.4030100@redhat.com>
Date: Thu, 04 Oct 2007 20:10:31 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: William Cattey <wdc@MIT.EDU>
CC: Andi Kleen <andi@firstfloor.org>, Chuck Anderson <cra@WPI.EDU>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu> <20070814212858.GB23308@one.firstfloor.org> <07759638-DE7C-4341-A642-D611A897614F@MIT.EDU> <20070814214622.GE23308@one.firstfloor.org> <6655DD8B-D9C6-495D-9E22-2FDF6B375C9D@MIT.EDU> <20070814221927.GH23308@one.firstfloor.org> <9D5ACA40-5F33-4F49-8255-D51F554889E7@MIT.EDU> <4702758A.20205@redhat.com> <42824DD7-AD58-4C2C-A15C-C88EBFAC2C56@MIT.EDU>
In-Reply-To: <42824DD7-AD58-4C2C-A15C-C88EBFAC2C56@MIT.EDU>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2007 07:58 PM, William Cattey wrote:
> 
> Sadly, the effect of the patch is the same as the most recent candidate
> patch from Jeremy Fitzhardinge:  The EDID transfer still comes up all
> zeros.
> 

I think maybe a better question is: why does read_edid still work?
The X server might be making some invalid assumption about system
state. Comparing the code the two programs use could provide some clues.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764631AbXGFSA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764631AbXGFSA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762094AbXGFSAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:00:50 -0400
Received: from gw.goop.org ([64.81.55.164]:51914 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761029AbXGFSAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:00:49 -0400
Message-ID: <468E834E.6020906@goop.org>
Date: Fri, 06 Jul 2007 11:00:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Dan Kegel <dank@kegel.com>, linux-kernel@vger.kernel.org,
       Robert Walsh <rjwalsh@durables.org>
Subject: Re: Valgrinding the kernel?
References: <a71bd89a0707052114u28fed408h4326913c502a43ac@mail.gmail.com> <468DD6A5.4020705@goop.org> <20070706172513.GD10670@c2.user-mode-linux.org>
In-Reply-To: <20070706172513.GD10670@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> Don't think so.  With what I get on FC5 (valgrind-3.1.0), I get this:
>
> ==31913== Jump to the invalid address stated on the next line
> ==31913==    at 0x9: ???
> ==31913==    by 0xBEC1599A: ???
> ==31913==    by 0x696C2F69: ???
> ==31913==  Address 0x9 is not stack'd, malloc'd or (recently) free'd
> ==31913== 
> ==31913== Process terminating with default action of signal 11 (SIGSEGV): dumping core
>
> UML is cloning a thread in order to test the host's ptrace.  However,
> it looks like valgrind is branching to 0x9 for some reason.
>   

How far into the run does this happen?  Immediately, or after a while?

> This particular bit is going to be problematic for other reasons, but
> if valgrind ever looks like it has a chance of working, I can work
> around that in UML.
>   

Hm.  I haven't touched Valgrind in a couple of years, and I suspect 
people haven't been as mean to it as I was being.  It might be time I 
gave it some love.  (I've also been thinking about porting it to be a 
Xen guest so that we can Valgrind whole virtual machines - but that's a 
different story.)

    J

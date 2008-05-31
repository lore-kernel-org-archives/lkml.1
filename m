Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYEaQtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYEaQtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYEaQtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:49:47 -0400
Received: from mailgw.cs.york.ac.uk ([144.32.40.3]:46734 "EHLO
	mailgw.cs.york.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbYEaQtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:49:46 -0400
Message-ID: <484180C7.3040701@student.cs.york.ac.uk>
Date: Sat, 31 May 2008 17:45:59 +0100
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Reply-To: alan-jenkins@tuffmail.co.uk
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alan Jenkins <aj504@cs.york.ac.uk>, Chris Frey <cdfrey@foursquare.net>,
       linux-kernel@vger.kernel.org
Subject: Re: OOM policy, overcommit control, and soft limits
References: <azwvH-5QW-5@gated-at.bofh.it>	<3849b91c-cfca-4126-b14b-aa6d2b4b10b3@m45g2000hsb.googlegroups.com> <20080531162341.4e183a09@core>
In-Reply-To: <20080531162341.4e183a09@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> In other words, I reckon I have on the order of a gigabyte of virtual
>> address space, which has been malloc'ed or equivalent, but is not used
>> and therefore requires no memory resource (ram or swap).
>>     
>
> No need to reckon. The committed_as in the proc file should give a rough
> value.
>
> Alan
>   
Thanks for the education.  I shall read up on the other numbers in 
/proc/meminfo as well.

In that case I was overly pessimistic.  I was only committed around the 
512M mark.  It jumps up to 750M if I open Amarok and Firefox though.  At 
times I've run more - I would guess I can contrive combinations which go 
above 1000M.


I've not had an OOM event on this machine.  I have had runaway 
development-related loads, causing thrashing (hitting swap) out of 
control, but I can't really comment.  I don't remember what caused it 
exactly.  Plus I'm swapping to a Flash drive; a Flash specific IO 
scheduler might have coped better (than noop) and made it easier to recover.

Alan

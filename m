Return-Path: <linux-kernel-owner+w=401wt.eu-S1764242AbYCGOJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764242AbYCGOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 09:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbYCGOJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 09:09:47 -0500
Received: from mx1.suse.de ([195.135.220.2]:41974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611AbYCGOJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 09:09:46 -0500
Date: Fri, 7 Mar 2008 15:09:40 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Andrew Haley <aph@redhat.com>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
In-Reply-To: <20080306220610.GB31833@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0803071507280.20583@wotan.suse.de>
References: <20080305202319.GA17053@volta.aurel32.net>
 <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <47CF0627.2070200@zytor.com>
 <47CF07FE.10200@aurel32.net> <47CFBF28.4060309@redhat.com>
 <871w6ogjnu.fsf@basil.nowhere.org> <84fc9c000803060406u7dfa0d38ve8af3154bf5064f9@mail.gmail.com>
 <20080306173438.GH17267@synopsys.com> <84fc9c000803061254i5865f68ev11fcfd08b698c58f@mail.gmail.com>
 <47D05A70.40008@zytor.com> <20080306220610.GB31833@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 6 Mar 2008, Andi Kleen wrote:

> To be realistic it is very unlikely anybody will measure a difference 
> from a few more or a few less clds in a program.

Only an assumption, and in fact wrong.  See upthread for a benchmark.  
IIRC Uros also made measurements to justify the removal of cld (on P4 I 
think), where it helps tremendously on small memcpy loops.


Ciao,
Michael.

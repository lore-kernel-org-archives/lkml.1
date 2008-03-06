Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbYCFPc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbYCFPc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYCFPcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:32:48 -0500
Received: from rock.gnat.com ([205.232.38.15]:38572 "EHLO rock.gnat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbYCFPcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:32:47 -0500
X-Greylist: delayed 1404 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 10:32:47 EST
Message-ID: <47D0091E.304@adacore.com>
Date: Thu, 06 Mar 2008 10:09:18 -0500
From: Robert Dewar <dewar@adacore.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
  flag
References: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> <47CF3F09.4080606@zytor.com> <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org>
In-Reply-To: <20080306135139.GA5236@dspnet.fr.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert wrote:
> On Wed, Mar 05, 2008 at 05:12:07PM -0800, H. Peter Anvin wrote:
>> It's a kernel bug, and it needs to be fixed.
> 
> I'm not convinced.  It's been that way for 15 years, it's that way in
> the BSD kernels, at that point it's a feature.  The bug is in the
> documentation, nowhere else.  And in gcc for blindly trusting the
> documentation.

I agree, it reminds me of Burroughs on the 5500 believing the
Fortran standard which carefully allowed for a stack based
implementation of Fortran, Algol-style, unfortunately no real
Fortran programs worked with this semantics, and it was one of
the factors contributing the demise of the 5500.
> 
>   OG.
> 


Return-Path: <linux-kernel-owner+w=401wt.eu-S934072AbYCFP5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072AbYCFP5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762377AbYCFP5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:57:14 -0500
Received: from rock.gnat.com ([205.232.38.15]:39626 "EHLO rock.gnat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761591AbYCFP5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:57:13 -0500
Message-ID: <47D01457.30001@adacore.com>
Date: Thu, 06 Mar 2008 10:57:11 -0500
From: Robert Dewar <dewar@adacore.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: NightStrike <nightstrike@gmail.com>
CC: Olivier Galibert <galibert@pobox.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> 	 <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> 	 <47CF11D6.7070901@zytor.com> 	 <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> 	 <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> 	 <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> 	 <47CF3F09.4080606@zytor.com> 	 <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> 	 <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org> <b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com>
In-Reply-To: <b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NightStrike wrote:
> On 3/6/08, Olivier Galibert <galibert@pobox.com> wrote:
>> On Wed, Mar 05, 2008 at 05:12:07PM -0800, H. Peter Anvin wrote:
>>> It's a kernel bug, and it needs to be fixed.
>> I'm not convinced.  It's been that way for 15 years, it's that way in
>> the BSD kernels, at that point it's a feature.  The bug is in the
>> documentation, nowhere else.  And in gcc for blindly trusting the
>> documentation.
> 
> The issue should not be evaluated as: "It's always been that way,
> therefore, it's right."  Instead, it should be: "What's the right way
> to do it?"
> 
> You don't just change documentation because no existing code meets the
> requirement -- UNLESS -- the non-conforming code is actually the right
> way to do things.

Sounds good, but has almost nothing to do with the real world. I 
remember back in Realia COBOL days, we had to carefully copy IBM
bugs in the IBM mainframe COBOL compiler. Doing things right and
fixing the bug would have been the right thing to do, but no one
would have used Realia COBOL :-)

Another story, the sad story of the intel chip (I think it was
the 80188) where Intel made use of Int 5, which was documented
as reserved. Unfortunately, Microsoft/IBM had used this for
print screen or some such. Intel was absolutely right that
their documentation was clear and it was wrong to have used
these interrupts .. but the result was a warehouse of unused
chips.

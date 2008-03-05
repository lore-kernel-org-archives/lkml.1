Return-Path: <linux-kernel-owner+w=401wt.eu-S1763190AbYCEVp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763190AbYCEVp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763559AbYCEVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:44:37 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:17518 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763536AbYCEVog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:44:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IUR0at2OcEDMhc7yQ4C1UzxTJxo4T7lDc5I5/enFXiT+SLAHw3q4ru0+5tBqtmy3oupaJkWhxTYy17jguXgjANt2TJEkw3wj200ln7fitLdLy++JcbWfzt850H7n/854fuMzM5RJh+KWr9tElvgTdP7yuFi8o0BMML4mXVj7tFU=
Message-ID: <84fc9c000803051344q3294d02cvaf860e345b923077@mail.gmail.com>
Date: Wed, 5 Mar 2008 22:44:35 +0100
From: "Richard Guenther" <richard.guenther@gmail.com>
To: "Joe Buck" <Joe.Buck@synopsys.com>
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Michael Matz" <matz@suse.de>,
       "Jan Hubicka" <hubicka@ucw.cz>, "Aurelien Jarno" <aurelien@aurel32.net>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
In-Reply-To: <20080305214311.GD17267@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47CEC3AA.6080709@zytor.com>
	 <20080305202319.GA17053@volta.aurel32.net>
	 <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
	 <20080305204234.GB17267@synopsys.com>
	 <20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
	 <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
	 <20080305212005.GC17267@synopsys.com>
	 <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
	 <47CF11D6.7070901@zytor.com> <20080305214311.GD17267@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 10:43 PM, Joe Buck <Joe.Buck@synopsys.com> wrote:
>
> On Wed, Mar 05, 2008 at 01:34:14PM -0800, H. Peter Anvin wrote:
>  > Richard Guenther wrote:
>  > >
>  > >We didn't yet run into this issue and build openSUSE with 4.3 since more
>  > >than
>  > >three month.
>  > >
>  >
>  > Well, how often do you take a trap inside an overlapping memmove()?
>
>  Also, would it be possible to produce an exploit?  If you can get string
>  instructions to work "the wrong way", you might be able to overwrite data.
>
>  "We haven't seen a problem" isn't the right answer.  Can someone
>  deliberately *create* a problem?
>
>  And if we aren't sure, we should err on the side of safety.

Oh, you mean releasing a kernel security update? ;)  What does ICC or
other compilers do?

Richard.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762911AbXEVRN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762911AbXEVRN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbXEVRNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:13:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:6841 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbXEVRNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W4oZ/rwWeh1ROxn6dHNs1F9xI1S41djQn/mHCx2lrs3xlC2xUNB8mVsVA52RXrn5sFBVhDgNjFXQ2As3M7QfgN3WUaJnj839PebnJFsS9l2zkgE6JplRk4Aojp+6YIeJe9HE/2eC4iRJKqJtSEgg5cL4lPW7hLc1nHeLwisz+v0=
Message-ID: <a781481a0705221013m45f82054tca9a9a78ea8935d4@mail.gmail.com>
Date: Tue, 22 May 2007 22:43:16 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>, "Adrian Bunk" <bunk@stusta.de>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <46532247.6030803@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <4650074A.6000307@s5r6.in-berlin.de>
	 <a781481a0705200438s634712e6v957d7085bca7407@mail.gmail.com>
	 <46503542.50300@s5r6.in-berlin.de>
	 <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>
	 <46504876.9040802@s5r6.in-berlin.de>
	 <a781481a0705200650v2ef7be85h19f8c8eb026a303b@mail.gmail.com>
	 <46505DBD.5010005@s5r6.in-berlin.de>
	 <a781481a0705220753g25bb0dd8u33bbf8ddaf00f50c@mail.gmail.com>
	 <46532247.6030803@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Satyam Sharma wrote:
> > On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> > On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> >> config A
> >> >>         bool-or-tristate "option A"
> >> >>         depends on !PLATFORM_X || HELPER_N_ON_PLATFORM_X
> [...]
> > Umm, if A requires helper code N (which is available only on platform X),
> [And, I assumed, 'A' works without helper 'N' on all platforms except
> 'X'.
> This is a synthetic example which might not have a real-world application.]

Well, it is not relevant / equivalent to any of the four symbols that caused the
warnings that this thread is about, at least.

> > then why/how do we want A to depend on platforms _other_ than X?
>
> The expression means:  'A' can be enabled on all platforms.  Except on
> platform_X, there it can only be enabled if helper_N is built too.
> [...]
> No.  I meant "(X && N_ON_X) || Any_one_platform_other_than_X" above.

Yeah, and as I said, this was totally *not* the problem being discussed /
solved in this thread (and by that patch).

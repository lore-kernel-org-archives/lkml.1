Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbXAZXhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbXAZXhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 18:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXAZXhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 18:37:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:17137 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbXAZXhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 18:37:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=FCPAa5lhAk4HI1kEihJRkQQgcRCSE5EcGeKWFeBByn0GkApm4Cw3trsjE1t/dlnkR0sg56HMP8kWWZ8PoyDiOp4tyDtRdlSTC6r1Q3vtkTCn1RHiOVMWDn5hL96E/7OXd3NVoDS64OuOaSmAmj9QYnQ0hpuFbmXcQs37QiwmtLw=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: O_DIRECT question
Date: Sat, 27 Jan 2007 00:35:31 +0100
User-Agent: KMail/1.8.2
Cc: Michael Tokarev <mjt@tls.msk.ru>, Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org, kenneth.w.chen@in
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701252211.39017.vda.linux@googlemail.com> <45BA4720.5010406@tmr.com>
In-Reply-To: <45BA4720.5010406@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701270035.31285.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 19:23, Bill Davidsen wrote:
> Denis Vlasenko wrote:
> > On Thursday 25 January 2007 21:45, Michael Tokarev wrote:
> >> Phillip Susi wrote:
> >>> Denis Vlasenko wrote:
> >>>> You mean "You can use aio_write" ?
> >>> Exactly.  You generally don't use O_DIRECT without aio.  Combining the
> >>> two is what gives the big win.
> >> Well, it's not only aio.  Multithreaded I/O also helps alot -- all this,
> >> say, to utilize a raid array with many spindles.
> >>
> >> But even single-threaded I/O but in large quantities benefits from O_DIRECT
> >> significantly, and I pointed this out before.
> > 
> > Which shouldn't be true. There is no fundamental reason why
> > ordinary writes should be slower than O_DIRECT.
> > 
> Other than the copy to buffer taking CPU and memory resources.

It is not required by any standard that I know. Kernel can be smarter
and avoid that if it can.
--
vda

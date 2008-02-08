Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbYBHHFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbYBHHFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbYBHHFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:05:06 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52590
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbYBHHFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:05:04 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.24 says "serial8250: too much work for irq4" a lot.
Date: Fri, 8 Feb 2008 01:04:52 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <200802051455.10831.rob@landley.net> <200802071413.45085.rob@landley.net> <47AB75EB.3040405@zytor.com>
In-Reply-To: <47AB75EB.3040405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802080104.54081.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2008 15:19:39 H. Peter Anvin wrote:
> Rob Landley wrote:
> > Specifically, qemu isn't paravirtualized, it's fully virtualized.  The
> > same kernel can run on real hardware just fine.  (Sort of the point of
> > the project...)
> >
> > I can yank the warning for the kernels I build (or set PASS_LIMIT to
> > 9999999), but I'd rather not carry any more patches than I can avoid...
>
> Patch attached, completely untested beyond compilation.
>
> In particular:
>
> 	- we should probably clear the burst counter when the interrupt
> 	  line goes from inactive to active.
> 	- there probably should be a timer which clears the burst
>   	  counter.
>
> However, I think I've covered most of the bases...

Well, qemu still seems to work with the patch applied, and I haven't 
reproduced the error message yet...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

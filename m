Return-Path: <linux-kernel-owner+w=401wt.eu-S934459AbYBGUOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbYBGUOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbYBGUNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:13:51 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50890
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756851AbYBGUNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:13:49 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.24 says "serial8250: too much work for irq4" a lot.
Date: Thu, 7 Feb 2008 14:13:44 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <200802051455.10831.rob@landley.net> <20080207123937.GC15647@elte.hu> <47AB41C8.3010001@zytor.com>
In-Reply-To: <47AB41C8.3010001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071413.45085.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2008 11:37:12 H. Peter Anvin wrote:
> > actually, the way i solved it for qemu+KVM+paravirt was to just turn off
> > this rather silly check in the serial driver if inside a paravirt guest.
> > When we are emulated then the serial 'hardware' is totally reliable and
> > we should just trust it. That way i never dropped a single bit of kernel
> > log output again.
>
> Yes, but keying that on paravirt is silly in the extreme.  After all,
> there is no need for this to be paravirtualized.
>
> 	-hpa

Specifically, qemu isn't paravirtualized, it's fully virtualized.  The same 
kernel can run on real hardware just fine.  (Sort of the point of the 
project...)

I can yank the warning for the kernels I build (or set PASS_LIMIT to 9999999), 
but I'd rather not carry any more patches than I can avoid...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

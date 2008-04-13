Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYDMWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYDMWcf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYDMWc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:32:27 -0400
Received: from rv-out-0708.google.com ([209.85.198.245]:18881 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752267AbYDMWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:32:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oyacEJSNFFTiio94CsUipQodYPV9dLDjKqpXtyUSZq1KE3mTXyRlirYLd8pBvnF4jYbXmFq8vfaxTw4KalVIgwf70/SJloalcuZmWcSp9D/z5MGMLeUtUUbXzrSVnh8QpXleO/3jbFaYSxLb2ugKi6iNOylpi1743oGIfimQOW4=
Message-ID: <86802c440804131532g4626233br82a425d6a96a6e11@mail.gmail.com>
Date: Sun, 13 Apr 2008 15:32:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: x86 git tree broken (bisected)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <200804140010.01034.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102159.14563.rjw@sisk.pl> <200804131812.55684.rjw@sisk.pl>
	 <86802c440804131500q420f7442hd8512cc6f4a1a6fd@mail.gmail.com>
	 <200804140010.01034.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 3:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> On Monday, 14 of April 2008, Yinghai Lu wrote:
>  > On Sun, Apr 13, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > ...
>  > >  > can you try to apply the patch i sent to you about agp bridge order
>  > >  > reading for buggy silicon?
>  > >  >
>  > >  > Please boot kernel with "debug"...
>  > >  >
>  > >  > I want to verify if you can get
>  > >  >
>  > >  > "
>  > >  > Aperture conflicts with PCI mapping.
>  > >  > "
>  > >  >
>  > >  > in your boot log...
>  > >
>  > >  It's not present in there:
>  > >
>  > >  rafael@albercik:~> grep Aperture failing-with-patch-dmesg.log
>  > >  Aperture too small (32 MB)
>  > >  Aperture from AGP @ de000000 size 4096 MB (APSIZE 0)
>  > >  Aperture too small (0 MB)
>  > >  agpgart: Aperture pointing to RAM
>  > >  agpgart: Aperture from AGP @ de000000 size 4096 MB
>  > >  agpgart: Aperture too small (0 MB)
>  > >
>  > >  Full dmesg output attached.
>  >
>  > please check attached debug patch. and check if you can change GART
>  > size in your BIOS setup to 64M instead of 32M
>
>  Hm, what tree am I supposed to apply it too:
>  (1) current x86 git
>  (2) current x86 git w/ some of your previous patches (which ones in this case)
>  (3) failing (old) x86 git
>  (4) failing (old) x86 git w/ some of your previous patches (which ones in this
>     case)?

(1) current x86.git

Thanks

Yinghai Lu

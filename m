Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbYDMRyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbYDMRyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYDMRyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:54:12 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:65498 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYDMRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OyoFi+TSfl92sbc1665SV/pw8+EvojYntlsE5AfrE+91CcgUMwGKPMXFp2J4nMdKVBMZMz+fCUDF+U2X+hTGJLrLRuISIJqtMEerqL1n/2hZYGUVjCSCHbFxeO6f9kGkhh9M7j9t6Y6AxnQoC7nepZy2iPR2vWsWM0YnJAIas7k=
Message-ID: <86802c440804131054y73fa94e3jd12172d206eea510@mail.gmail.com>
Date: Sun, 13 Apr 2008 10:54:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Christoph Pfister" <christophpfister@gmail.com>
Subject: Re: apic doesn't work with 32bit kernel (fine with 64bit) [asus m2n-mx se+]
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200804131459.21494.christophpfister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804122120.53220.christophpfister@gmail.com>
	 <86802c440804121615g1c7782a0v9da5183559b8b99@mail.gmail.com>
	 <200804131459.21494.christophpfister@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 5:59 AM, Christoph Pfister
<christophpfister@gmail.com> wrote:
> Am Sonntag 13 April 2008 01:15:51 schrieb Yinghai Lu:
>
> > On Sat, Apr 12, 2008 at 12:20 PM, Christoph Pfister
>  >
>  > <christophpfister@gmail.com> wrote:
>  > > Hi,
>  > >
>  > >  Using a new motherboard, I came across a kernel panic (dmesg using
>  > > 2.6.25-rc9 [x86_32] transcribed from screenshot attached; also dmesg when
>  > >  using "apic=debug").
>  > >  The system works nearly fine when using "noapic" (setting rtc doesn't
>  > > work).
>  > >
>  > >  Everything (including apic and rtc) works like a charm when I use the
>  > > x86_64 version with (nearly) the same kernel config (dmesg attached as
>  > > well).
>  >
>  > how about booting 64 bit apic=debug?
>
>  Attached.
>
>
>  > wonder if using kexec to load 32bit kernel from 64 bit kernel help.
>
>  What should it help? Btw, grabbed a good old RS232 cable to get more than 25
>  lines of dmesg :) - attached as well.

only difference, it seems 32bit enable io_apic after all cpus up.  and
64 bit will enable that just after first cpu.

YH

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYDLXQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYDLXQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 19:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYDLXPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 19:15:52 -0400
Received: from rv-out-0708.google.com ([209.85.198.250]:3276 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753772AbYDLXPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 19:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HvX7C5LWEiEIfmAkJPN0sT2ChqXoFogHD5Qt9DPv3WXDkSdWD6G5C7Pmx5yVaEdlPoUJD2NMgm/ziKRr2jr86RaLmQLm3ISpg2x+NpL0GO7N34LgFIDTo7DtFyJ6F39Rq6jIkdRTCrZkMUO9T8OWh0F1KKPajnNM/fRcRPaHEis=
Message-ID: <86802c440804121615g1c7782a0v9da5183559b8b99@mail.gmail.com>
Date: Sat, 12 Apr 2008 16:15:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Christoph Pfister" <christophpfister@gmail.com>
Subject: Re: apic doesn't work with 32bit kernel (fine with 64bit) [asus m2n-mx se+]
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200804122120.53220.christophpfister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804122120.53220.christophpfister@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 12:20 PM, Christoph Pfister
<christophpfister@gmail.com> wrote:
> Hi,
>
>  Using a new motherboard, I came across a kernel panic (dmesg using 2.6.25-rc9
>  [x86_32] transcribed from screenshot attached; also dmesg when
>  using "apic=debug").
>  The system works nearly fine when using "noapic" (setting rtc doesn't work).
>
>  Everything (including apic and rtc) works like a charm when I use the x86_64
>  version with (nearly) the same kernel config (dmesg attached as well).
>
how about booting 64 bit apic=debug?

wonder if using kexec to load 32bit kernel from 64 bit kernel help.

YH

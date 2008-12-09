Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYLIHh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYLIHh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 02:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYLIHhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 02:37:14 -0500
Received: from ag-out-0708.google.com ([72.14.246.251]:40239 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYLIHhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 02:37:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o9Y861JSEd10iklSmcxMiiS7NOF/9YjFPuSi5UPJMnFBNeDu7MyzpXHcZAXI9yzefM
         QC/qZyFIUk8PwcEPjfuKAxChVsm64MgeN4o58WmxXgZHteVW0I43m72/GAkzbkO/05DB
         HvhBOzawuNTK/JRUpRiTJHhDEvli6G/TKRVlQ=
Message-ID: <12bfabe40812082337i2ec63201w710ba2cc4ef62c84@mail.gmail.com>
Date: Tue, 9 Dec 2008 08:37:10 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Mikael Abrahamsson" <swmike@swm.pp.se>
Subject: Re: OFFLIST Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Andi Kleen" <ak@linux.intel.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0812090737410.18782@uplift.swm.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493CF65B.30408@jp.fujitsu.com> <493D0D42.2090203@linux.intel.com>
	 <alpine.DEB.1.10.0812081314010.18782@uplift.swm.pp.se>
	 <493D296B.1080205@linux.intel.com>
	 <alpine.DEB.1.10.0812081724080.18782@uplift.swm.pp.se>
	 <493D6FB4.9090909@linux.intel.com>
	 <alpine.DEB.1.10.0812082145410.18782@uplift.swm.pp.se>
	 <12bfabe40812082146r3ea000em7a8f725101a50bd5@mail.gmail.com>
	 <alpine.DEB.1.10.0812090737410.18782@uplift.swm.pp.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2008 at 8:01 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Tue, 9 Dec 2008, Giangiacomo Mariotti wrote:
>
>> If it's not too much of a burden for you, could you please try the distro
>> named SystemRescueCd(www.sysresccd.org/Main_Page)? I tried the stable
>> release SystemRescueCd-x86-1.1.3, at boot just type rescue64 to boot in
>> 64bit mode(F2 tells you this). Notice that this distro will give you just a
>> shell after boot.
>
> Oki, I booted their 2.6.27.07-std113-amd64 kernel. According to messages log
> it booted at 07:28:10 (first entry).
>
> At 07:32:28 there is a log entry in dmesg and messages that says "Machine
> check events logged", so this seems to verify Giangiacomos problem. I did
> this twice, got the same error twice (second time booted at 07:49:10, got
> the error at 07:53:31).
>
> I do not get this message on their regular i386 kernel, tried once.
>
> mcelog is not installed on this rescue-cd and it didn't seem to have portage
> (I'm mostly a debian/ubuntu person with history of slackware and redhat) so
> I couldn't install it either.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
>

In its i386 version the mce didn't get logged for me too, but I
noticed something like an option for non critical MCEs wasn't
configured in the i386 kernel. That might be the cause, or it's just a
problem for the 64 bit version. Anyway, as I've already posted here
lkml.org/lkml/2008/12/9/4, rebooting with a kexec completely removes
the MCE, so I guess it's a bios problem.

I'm resending this just to put it back on the mailing list.

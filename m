Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbYHLFnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbYHLFnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYHLFnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:43:41 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:49658 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYHLFnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=klCsGlDsOd5Pb2ScG/xDEjrxWx7nw4jUIIEqt4yraed46Ome00vchI3BgsYC0AVugv
         qNLHrt1WvUlDTmFIOFbNlgaQ3lEqEhFs6pBUnHaFS/FDjqBGnVJg+5Sfl/GoIRY+nfGD
         0aG7l4erZlPE4xLJzAi7abTz/rpbHsK2ipiKA=
Message-ID: <514e099a0808112243r78a79e3ck19a1440962b5cb0@mail.gmail.com>
Date: Mon, 11 Aug 2008 22:43:38 -0700
From: "S K" <nospamnoham@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Cc: "Zhao Yakui" <yakui.zhao@intel.com>, "Thomas Renninger" <trenn@suse.de>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20080811132332.GR9038@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	 <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	 <200808092059.47863.trenn@suse.de>
	 <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
	 <1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
	 <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
	 <1218432270.6671.75.camel@yakui_zhao.sh.intel.com>
	 <874p5r3jow.fsf@basil.nowhere.org>
	 <514e099a0808110615i42ade5dctc31d87b483095e35@mail.gmail.com>
	 <20080811132332.GR9038@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow! Didn't mean to start a "tech war" here (point's at the long
thread arguing the use of p4-clockmod).

>> It works in Windows XP, so I'm not sure if it's only a BIOS issue.
>
> On Windows platform drivers sometimes provide a replacement DSDT
> that might enable cpufreq. If that's the case there's nothing
> we can do really on the Linux side. You might be able to extract
> that DSDT from somewhere and supply it to Linux as a replacement
> DSDT, but that's not a supported configuration in the kernel.

I don't remember installing any special driver for Windows XP.
Since you claim that as a possibility, is there something that I can look
for to check if this is the case?

The reason I'm questioning this so much is because I plan to contact
Shuttle tech support and try to get them to fix this if it really is a BIOS
issue. But I need valid points to make sure they don't pass on the
blame and slip away. They do seem to release BIOS updates now and then
so I'm hoping I can coax them to release one.

>> If it's not that simple, then care to impart some knowledge?
>
> If you can't get your BIOS to provide the necessary methods
> then useful Linux cpufreq won't work. It's that simple.
> p4-clockmod aka throttling might work, but it doesn't actually
> save energy and often causes severe performance problems.

I definitely don't want to use anything that will have a drastic
effect on performance.

Thanks,
SK

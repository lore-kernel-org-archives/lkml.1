Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbYFNL4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbYFNL4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 07:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYFNL4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 07:56:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:35791 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYFNL4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 07:56:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YjgdKhCKOXQ7UV+pQqsMLMIBkuxVDtx/XEMORsRYzo7nxYNCK7NItglSbpfArcNXjh
         fA/Ezhr+fk1fhsFmYqPiCjHpx9aLpjK1pfD1t6nYnsXSAkBqQKcvJdcYwhm9yyVvTJig
         YumWJDI1ZebORXcG/Biccml1bPtVCRz22uXMA=
Message-ID: <a5bf86a80806140456x271dfc31m2ba0583275d8adb0@mail.gmail.com>
Date: Sat, 14 Jun 2008 13:56:40 +0200
From: "Lior Dotan" <liodot@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [Bug 10866] /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       a.zummo@towertech.it,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, rtc-linux@googlegroups.com
In-Reply-To: <20080613212023.GB1716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dCRO4tbfLzK.A.rFC.L2vSIB@albercik>
	 <20080613193302.GA1716@cs181133002.pp.htv.fi>
	 <a5bf86a80806131255w704745d7mc109c13669ac9c68@mail.gmail.com>
	 <20080613212023.GB1716@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 11:20 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Fri, Jun 13, 2008 at 10:55:38PM +0300, Lior Dotan wrote:
>> On Fri, Jun 13, 2008 at 10:33 PM, Adrian Bunk <bunk@kernel.org> wrote:
>> > On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
>> >
>> > /dev/rtc (major 10, minor 135) does not seem to exist, and I'd call this
>> > a functional regression of the new drivers.
>> >
>> > Could this be fixed?
>>
>> I don't know if it helps you to decide but the way I got to this
>> configuration is by copying my working 2.6.25 .config file and running
>> make oldconfig. I think this scenario is common when upgrading to a
>> newer version so you should make sure it doesn't generate an invalid
>> configuration.
>
> What is the output of "grep RTC_ .config" on your old .config?

I don't have access to that machine right now so I'll post it tomorrow.

> cu
> Adrian
>

Cheers,
Lior

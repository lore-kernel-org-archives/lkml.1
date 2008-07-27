Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYG0Byc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYG0Byc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbYG0ByX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:54:23 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:48716 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756526AbYG0ByX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:54:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=l+awTocDD7qH2IN2dvrufr8R0z3mYq1q6DBXoEEtjMdoxhxdDKl1OmwHW3Zc3DeEI7YXM4YBmybttrEJu+9jVx4WLrh53ix/fijFbLZBBE3ubnr2PXpToNW4lRy4h9j5jz5qodWFORxXACODlKAxYegRrbAJUqM5ZGynT8TzurU=  ;
X-YMail-OSG: .b8MJOMVM1lVSyqH3yWfSd1KKTUcEm1xxQIQpIoX7s3Ggfr5DALQ7GLDvCf9..moRxUzv3JRtpUT5nUwHEjavVYgGAcfKLuI316g.JTxVOnQXKDykPIMj2mhqQ4u7sbJl_U-
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 26 Jul 2008 18:56:33 -0700
From: David Brownell <david-b@pacbell.net>
To: yhlu.kernel@gmail.com, gregkh@suse.de
Subject: Re: [PATCH] usb: don't hide bios bug warning
Cc: mingo@elte.hu, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200807261812.15836.yhlu.kernel@gmail.com>
 <20080727012454.GA22219@suse.de>
 <86802c440807261848g3bb3e87dh121d1f11f6f64d77@mail.gmail.com>
In-Reply-To: <86802c440807261848g3bb3e87dh121d1f11f6f64d77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080727015633.479B228C8F1@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> -                             dev_warn(&pdev->dev, "EHCI: BIOS handoff failed"
> >> +                             dev_printk(KERN_WARNING, &pdev->dev,
> >> +                                             "EHCI: BIOS handoff failed"
> >
> > This is the exact same thing, no change.
> >
> > confused,
>
> end user will not set CONFIG_USB_DEBUG, so that dev_warn will do nothing.

Yes it does ... KERN_WARNING != KERN_DEBUG, and it's the latter
which is toggled (via DEBUG) by CONFIG_USB_DEBUG...

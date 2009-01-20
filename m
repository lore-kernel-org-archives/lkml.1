Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbZATWh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbZATWh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZATWhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:37:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48312 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbZATWhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:37:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: [PATCH -stable] p54usb: fix traffic stalls / packet drop
Date: Tue, 20 Jan 2009 23:36:29 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Greg KH gr <gregkh@suse.de>, Artur Skawina <art.08.09@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Larry Finger" <Larry.Finger@lwfinger.net>,
       "Linux wireless" <linux-wireless@vger.kernel.org>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.vUD.KKRdJB@chimera> <200901202311.11854.chunkeey@web.de>
In-Reply-To: <200901202311.11854.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901202336.30083.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 January 2009, Christian Lamparter wrote:
> All p54usb devices need a explicit termination packet, in oder to finish the pending transfer properly.
> Else, the firmware could freeze, or simply drop the frame.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> Cc: stable <stable@kernel.org>
> ---
> Attached is the patch is for the stable series only.
> Bugzilla reference: http://bugzilla.kernel.org/show_bug.cgi?id=12260
> (wireless-testing needs a different one)
> 
> Rafael, I hope we can close this bug. Greg?

Sure, we can.

Thanks,
Rafael

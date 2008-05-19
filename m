Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYESIDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYESIDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYESICw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:02:52 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:57615 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYESICu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:02:50 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred until reload of ehci-hcd
Date: Mon, 19 May 2008 10:02:43 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.OcB.itBMIB@albercik>
In-Reply-To: <7wuznNhcUqC.A.OcB.itBMIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191002.43734.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 18 Mai 2008 13:13:55 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10630
> Subject		: USB devices plugged into dock are not discoverred until reload of ehci-hcd
> Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> Date		: 2008-05-05 10:02 (14 days old)
> References	: http://lkml.org/lkml/2008/5/5/77

Can you compile with USB_DEBUG and attach the "register" file from
/sys/modules/ehci_hcd to see whether an interrupt is pending?

	Regards
		Oliver



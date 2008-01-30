Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbYA3Rd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbYA3Rd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbYA3Rdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:33:50 -0500
Received: from senator.holtmann.net ([87.106.208.187]:41635 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbYA3Rdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:33:49 -0500
Subject: Re: [2.6.24] bcm203x bluetooth dongle does not work
From: Marcel Holtmann <marcel@holtmann.org>
To: Florian Lohoff <flo@rfc822.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080130164920.GA15071@paradigm.rfc822.org>
References: <20080130164920.GA15071@paradigm.rfc822.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 18:33:52 +0100
Message-Id: <1201714432.6218.101.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

> after trying around with my ancient bcm2033 bluetooth dongle i found it
> not working in 2.6.24 - I debugged udev and found it loading the
> firmware correctly but the device seems to have problems disconnecting.
> 
> I found an Ubuntu bug which mentions a patch which supposed to be
> 2.6.20 material. It still applies and fixes my problem:
> 
> Ubuntu Bug:
> 	https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/85247
> 
> Patch:
> 	http://launchpadlibrarian.net/7058766/bcm203x-2.6.20-backport.diff
> 
> So it seems this patch never went in but most likely should.

we moved away from using a timer and using a workqueue now. It wrote the
patch to use a workqueue and tested that it works. Starting with 2.6.19
we the usage of a workqueue is default. Can you verify that non of the
kernels 2.6.19-2.6.23 are working. We might have missed a change inside
the USB subsystem within the 2.6.24 timeframe.

Regards

Marcel



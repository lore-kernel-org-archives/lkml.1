Return-Path: <linux-kernel-owner+w=401wt.eu-S966747AbXG3Rt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966747AbXG3Rt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932709AbXG3Rts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:49:48 -0400
Received: from Mnaem01-s3.macomp.com ([204.15.179.236]:1447 "EHLO
	mnaem01-s3.macomp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761948AbXG3Rtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:49:47 -0400
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 13:49:47 EDT
X-PMWin-Version: 2.6.1, Antispam-Engine: 2.5.1, Antivirus-Engine: 2.47.0
thread-index: AcfSz5AOGipZgqqwSw+aW51RnOwW6w==
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.2929
Subject: Re: k8temp on 2.6.18
From: "Jeff Garrett" <jgarrett@teamhpc.com>
To: "Clemens Koller" <clemens.koller@anagramm.de>
Cc: "shacky" <shacky83@gmail.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <46AE1C9C.90907@anagramm.de>
References: <7fedbc910707300638w4ac174edleb7a6eac2104cb85@mail.gmail.com> <46AE1C9C.90907@anagramm.de>
Content-Type: text/plain;
	charset="iso-8859-1"
Date: Mon, 30 Jul 2007 12:33:32 -0500
Message-ID: <1185816812.5876.25.camel@thog>
MIME-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2007 17:32:12.0000 (UTC) FILETIME=[900A3600:01C7D2CF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 19:15 +0200, Clemens Koller wrote:
> shacky schrieb:
> > Hi.
> > I'm using the 2.6.18 kernel (and I cannot upgrade it), but I need the
> > "k8temp" module which is available only from the 2.6.21 version.
> > Is there a way to use this module on my 2.6.18?
> 
> What is your problem that you cannot upgrade your kernel?
> 
> Backporting the k8temp is propably more difficult as installing
> a newer kernel. Have a look at:
> http://lists.debian.org/debian-amd64/2007/03/msg00005.html
> 
> Regards,

Actually k8temp is pretty easy.  I think the only thing necessary is
adding:
#define PCI_DEVICE_ID_AMD_K8_NB_MISC 0x1103

Then the module can be compiled out-of-tree as usual and should work.

-Jeff Garrett
TeamHPC


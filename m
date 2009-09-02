Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZIBRxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZIBRxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 13:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZIBRxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 13:53:02 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:61314 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbZIBRxB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 13:53:01 -0400
From: Frans Pop <elendil@planet.nl>
To: Christian =?iso-8859-1?q?Kr=E4mer?= <christian@kraemer-eu.de>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Wed, 2 Sep 2009 19:53:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200909021856.29565.christian@kraemer-eu.de>
In-reply-To: <200909021856.29565.christian@kraemer-eu.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909021953.02190.elendil@planet.nl>
X-OriginalArrivalTime: 02 Sep 2009 17:53:02.0798 (UTC) FILETIME=[379596E0:01CA2BF6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Krämer wrote:
> I used a Gentoo LiveCD (Kernel 2.6.24-gentoo-r7; Platform: x86)

That's a pretty old kernel. Any chance that you can try with a more recent
one, such as 2.6.30? Or maybe just a more recent Gentoo CD or live CD from
another distribution?

Also, did you see these following messages?
 
> pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwsetup.
> pcmcia: This interface will soon be removed from the kernel; please
> expect breakage unless you upgrade to new tools.
> pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for
> details.
> warning: process `hwsetup' used the deprecated sysctl system call with 1.49.
> warning: process `hwsetup' used the deprecated sysctl system call with 1.49.

It looks as if that Gentoo CD is still using the deprecated pcmcia-cs utilities
instead of the new pcmciautils.

Hope that helps,
FJP

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYHTUXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYHTUXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYHTUWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:22:48 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:54044 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbYHTUWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:22:48 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: amruth_pv@yahoo.com
Subject: Re: USB Serial device disconnect causes IRQ disable
Date: Wed, 20 Aug 2008 22:23:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <343002.57461.qm@web45206.mail.sp1.yahoo.com>
In-Reply-To: <343002.57461.qm@web45206.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808202223.57842.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 20 August 2008 21:34:51 schrieb amruth:
> Hi
> I again encountered the same issue IRQ23 disabled.
> Here is my /proc/interrupts

There is some unknown interrupt on 23. Try unloading
drivers until it works. You can sort of bisect it if you divide
your loaded modules in groups.

	Regards
		Oliver

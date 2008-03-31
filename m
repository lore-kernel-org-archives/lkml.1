Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbYCaLgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbYCaLgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYCaLgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:36:25 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:54387 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbYCaLgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:36:24 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.25-rc7:  Ugh.
Date: Mon, 31 Mar 2008 13:55:03 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz
References: <47EBBD57.30902@rtr.ca> <20080328092428.GA2081@elf.ucw.cz> <47F00059.1010108@rtr.ca>
In-Reply-To: <47F00059.1010108@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803311355.06487.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 30. März 2008 23:04:25 schrieb Mark Lord:
> >> Correction there:  3GB of RAM, not 2.
> > 
> > 3GB of RAM can be a problem. Try iommu=soft. .. but in such case
> > rmmod/insmod of usbhid would not help...
> ..
> 
> Booted with mem=2GB, and USB hung again on the first suspend/resume cycle.

Are you running with CONFIG_USB_SUSPEND? If so, please try without it.

	Regards
		Oliver

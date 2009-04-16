Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZDPNmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZDPNmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbZDPNmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:42:42 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55449 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZDPNml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:42:41 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Corrado Zoccolo <czoccolo@gmail.com>, linux-usb@vger.kernel.org
Subject: Re: linux-2.6.30rc1 mouse stuck with usb autosuspend enabled
Date: Thu, 16 Apr 2009 15:43:04 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, oliver@neukum.name,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>
References: <4e5e476b0904091453m61ec4e81j7cfdef918bb3dfb3@mail.gmail.com> <alpine.LRH.2.00.0904161210450.10907@twin.jikos.cz> <4e5e476b0904160545h1f384dbdx4161a0a304ad4c80@mail.gmail.com>
In-Reply-To: <4e5e476b0904160545h1f384dbdx4161a0a304ad4c80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904161543.06238.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 16 April 2009 14:45:12 schrieb Corrado Zoccolo:
> > Your mouse (as many other mice out there) doesn't emit wakeup event on
> > movement, it only does on button click. There is nothing kernel can do
> > about it. This is one of the reasons why autosuspend is disabled by
> > default (other reason being many devices broken beyond hope when it comes
> > to waking up).
>
> Well, to me it seems a regression since it worked correctly in 2.6.29, i.e.
> * it was suspended after inactivity (at least according to powertop),

This is not the reliable way to check this. Please compile 2.6.29 with
CONFIG_USB_DEBUG and post dmesg for a period of inactivity.

	Regards
		Oliver


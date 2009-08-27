Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbZH0UJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbZH0UJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 16:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZH0UI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 16:08:56 -0400
Received: from mail-pz0-f178.google.com ([209.85.222.178]:51793 "EHLO
	mail-pz0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZH0UIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 16:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=Su9r44nnY59XRH2vVI2vL1pDRitbmbkFzQ7PuT7IkGMTKtDPI+cZ6os/OPQo6Rzxc/
         dMcovPFmkuSvkLVZXjrpq3trtRSG9QtndcUdJ0ByRjE+Ua4328H8S5oMQZ6Rb/8qgKAH
         xr8jJ495i2raXBkjBB38c2A8uNyB36ydHxmL0=
Date: Thu, 27 Aug 2009 13:08:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 6/6] PM: Allow serio input devices to suspend/resume
	asynchronously
References: <200908262217.19609.rjw@sisk.pl> <200908262224.19110.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908262224.19110.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090827204106.1132B526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 10:24:19PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Set async_suspend for all serio input devices, so that they can be
> suspended and resumed asynchronously with other devices they don't
> depend on in a known way (i.e. devices which are not their parents
> or children and to which they are not connected via struct pm_link
> objects).
> 

As I mentioned not yet, please - i8042 may be unhappy if you pound
all its ports at once. I should have a solution for it though.

-- 
Dmitry

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYKNDbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYKNDbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYKNDbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:31:20 -0500
Received: from kroah.org ([198.145.64.141]:38968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751618AbYKNDbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:31:19 -0500
Date: Thu, 13 Nov 2008 19:27:59 -0800
From: Greg KH <greg@kroah.com>
To: Andiry Xu <andiry.xu@amd.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       volker.armin.hemmann@tu-clausthal.de, shane.huang@amd.com,
       libin.yang@amd.com
Subject: Re: [PATCH] usb: fix SB700 usb subsystem hang bug
Message-ID: <20081114032759.GD15204@kroah.com>
References: <1226632708.5796.28.camel@crane-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226632708.5796.28.camel@crane-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 11:18:28AM +0800, Andiry Xu wrote:
> This patch is required for AMD SB700 south bridge revision A12 and A13 to avoid
> USB subsystem hang symptom. The USB subsystem hang symptom is observed when the
> system has multiple USB devices connected to it. In some cases a USB hub may be
> required to observe this symptom.
> 
> This patch works around the problem by correcting the internal register setting
> that will help by changing the behavior of the internal logic to avoid the
> USB subsystem hang issue. The change in the behavior of the logic does not
> impact the normal operation of the USB subsystem.
> 
> Signed-off-by: Andiry Xu <andiry.xu@amd.com>
> Signed-off-by: Libin Yang <libin.yang@amd.com>

Care to add the "Reported-by:" and "Tested-by:" lines for the people who
helped bring this to your attention and resend it?

thanks,

greg k-h

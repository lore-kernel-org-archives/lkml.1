Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbYEVNmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbYEVNmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbYEVNly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:41:54 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:35372 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYEVNlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MdK6fDJGTw1nv4S4wKfusGmTbxCHVnCImlsTZwuZ1IE2Q5Nvq4CW0f7RCVr1IT66z/OleoL7C6pECmreT9tYqEI+tCrKq9C/Ja53QYDDoRFpdaUkx/ZRsZu/4CQFW6ftUKPIlXU+eLbqyS8J+suG1dvdylUfoue8Mu3dp30M+hY=
Date: Thu, 22 May 2008 09:41:48 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] wm97xx-core: Report a phys for WM97xx touchscreens
Message-ID: <20080522093759.ZZRA012@mailhub.coreip.homeip.net>
References: <1211456106-10882-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211456106-10882-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, May 22, 2008 at 12:35:06PM +0100, Mark Brown wrote:
> phys is displayed in various diagnostic output so ensure that it is set
> to something sensible.
>

Phys is used to describe the physical connection of a device that is
ideally not changing between reboots so having it set up based on
device's bus_id is not a best option I think.

What tools besides evbug use phys? They probably should display both
phys and sysfs paths (I will be changing evbug soon).

-- 
Dmitry

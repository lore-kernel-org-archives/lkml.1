Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYABKnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYABKnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYABKm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:42:58 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:26474 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbYABKm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:42:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=V0lurF56ooP2WAxG2ANTty527pw2ONwmzWX6aw2DSpMxhoJWWq5XZfiRDOdkBY8mYfGEJpZUcZZvu/SGccjggZ5l0Fc9MogzFPhGpajf8g/fE3Gylm+K+Lvmn+PINdpMomf4mIv5pO5y3fRH2O9Ld0TyCqO9YKjangTnYxR6X4s=
Message-ID: <477B6AA5.5020803@gmail.com>
Date: Wed, 02 Jan 2008 13:42:45 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: hal@lists.freedesktop.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: kpowersave stuck at battery charging
References: <200801021248.55844.arvidjaar@mail.ru>
In-Reply-To: <200801021248.55844.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> This is did not happen before; I am not sure right now what caused this (i.e. 
> battery aging or some software change) nor whether this is kernel/HAL/kpowersave 
> issue.
>
> kpowersave is stuck at assuming battery is loading and at 94%. Sysfs displays 
> battery state as Full:
>
>   
Frequent battery charging shortens lifetime of the battery, so some (may 
be all now)
notebook manufacturers do not start charging  battery until it discharge 
to some degree (~90%).
It could be your case. Please try to discharge battery to, say, 89% and 
then check if it charges to the
100%.
> - does ACPI battery code misuse POWER_SUPPLY_PROP_ENERGY_FULL?
> - does HAL misuse .../energy_full?
> - does kpowersave misuse battery.charge_level.last_full?
>   


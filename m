Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300AbYE1Oj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbYE1Oj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYE1OjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:39:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:58820 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYE1OjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rhnmsUzUXf/cA9S/OTDMJEOPwqL2kmSJ3V4hcKNoitNVqyAug7Yrwsnw7lFlxBVY+epNIZy60k2lHuoLsoFlRuGxPpVRfpdnYuuduR0xf/qqVuUbFFUNcgQYq6CnLGA0SFXsP6Cu5jeJ4Wlhm5pYm6Bb2MJ58FKXDzLMfjJ/oKc=
Message-ID: <483D6E8D.7030409@gmail.com>
Date: Wed, 28 May 2008 23:39:09 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
References: <20080528143857.GB5585@homac.suse.de>
In-Reply-To: <20080528143857.GB5585@homac.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holger Macht wrote:
> * Differentiate between bay devices in dock stations and others:
> 
>  - When an ACPI_NOTIFY_EJECT_REQUEST appears, just signal uevent to
>    userspace (that is when the optional eject button on a bay device is
>    pressed/pulled) giving the possibility to unmount file systems and to
>    clean up. Also, only send uevent in case we get an EJECT_REQUEST
>    without doing anything else. In other cases, you'll get an add/remove
>    event because libata attaches/detaches the device.
> 
>  - In case of a dock event, which in turn signals an
>    ACPI_NOTIFY_EJECT_REQUEST, immediately detach the device, because it
>    may already have been gone
> 
> * In case of an ACPI_NOTIFY_DEVICE/BUS_CHECK, evaluate _STA to check if
>   the device has been plugged or unplugged. If plugged, hotplug it, if
>   unplugged, just signal event to userspace
>   (initial patch by Matthew Garrett <mjg59@srcf.ucam.org>)
> 
> * Call ACPI _EJ0 for detached devices
> 
> Signed-off-by: Holger Macht <hmacht@suse.de>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun

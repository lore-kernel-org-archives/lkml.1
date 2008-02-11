Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbYBKXb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbYBKXb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYBKXbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:31:18 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:5993 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYBKXbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:31:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TENqf4QGE9slW+LKpzzGm+sVMLsJP3zo8Ky6uqpxWoitBaZKq81OUoqrKQN+SBUx9kyxAFRIgdabG5btX26+fkdHrcs6eQjFJsydr10gzdaZFVB8qlz58hqaKYRKhxGv3xchaxfk+uZn0Kv9MBAMpmV+yAVBPHjFFznKNVpWi+o=
Message-ID: <47B0DABC.6080703@gmail.com>
Date: Tue, 12 Feb 2008 08:31:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@redhat.com, jeff@garzik.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Forcing PIO0 mode on reset must not freeze	system
References: <20080210195556.GA5261@homac> <47AFB4DB.1000204@gmail.com> <20080211100446.GA4646@homac.suse.de> <47B02E96.4050900@gmail.com> <20080211112802.GA4528@homac.suse.de> <47B04984.1020401@gmail.com> <20080211140603.GA4576@homac.suse.de>
In-Reply-To: <20080211140603.GA4576@homac.suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holger Macht wrote:
> On a related note, shouldn't ata_acpi_handle_hotplug delete the device
> like what is done when doing
> 
>   echo 1 > /sys/devices/.../block/sr0/device/delete

Yeap, when the ata_acpi_handle_hotplug() was added, the focus was
supporting hotplug when the controller itself doesn't have hotplug
notification.  Removing device for undocking would need explicitly
killing it.

-- 
tejun

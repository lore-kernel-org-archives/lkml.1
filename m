Return-Path: <linux-kernel-owner+w=401wt.eu-S1751011AbZKNRy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751011AbZKNRy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 12:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZKNRy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 12:54:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:58174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZKNRy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 12:54:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: venu <vjosyula@gmail.com>
Subject: Re: firmware loading interface
Date: Sat, 14 Nov 2009 18:54:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Philip Downer <phil@csldevices.co.uk>, linux-kernel@vger.kernel.org
References: <4AFD971C.3090204@csldevices.co.uk> <200911132029.01432.arnd@arndb.de> <53ea87da0911140951q1050212fwe9f5839b900b3804@mail.gmail.com>
In-Reply-To: <53ea87da0911140951q1050212fwe9f5839b900b3804@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911141854.48783.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/gDirfkVpI/3XgG8Di+taJ4awFD+TWUUuVrzC
 2s4+Y9kd9yeuGcti5TYhhJsZfcthy1h3uaBNZXqd8IEYg+mivU
 aiK5+6wxhxCtPu+OZqVAw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 November 2009, venu wrote:
> Hi Arnd,
> 
> When the driver calls the request_firmware during initialization where is
> the firmware stored. What mean to ask is where the path it picks th firmware
> from ?

See Documentation/firmware_class/README. The file name is hardcoded
in the device driver. The path is part of the hotplug implementation,
typicaly /lib/firmware.

	Arnd <><

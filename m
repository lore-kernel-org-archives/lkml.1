Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbZLGOuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbZLGOuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932665AbZLGOuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:50:22 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52130 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbZLGOuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:50:19 -0500
MIME-Version: 1.0
In-Reply-To: <1259581514-15356-1-git-send-email-amit.kucheria@verdurent.com>
References: <1259581514-15356-1-git-send-email-amit.kucheria@verdurent.com>
Date: Mon, 7 Dec 2009 16:50:23 +0200
Message-ID: <37786d4b0912070650g7ba7604bv63365a21f980501d@mail.gmail.com>
Subject: Re: [PATCHv2 0/2] Introducing the Ambient Light Sensor (ALS) class
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rui.zhang@intel.com, jic23@cam.ac.uk, khali@linux-fr.org,
       alan@linux.intel.com, linux-acpi@vger.kernel.org, gregkh@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 1:45 PM, Amit Kucheria
<amit.kucheria@verdurent.com> wrote:
> Introduce a new class of devices to handle ambient light sensors. Currently
> only one sysfs inteface, 'illuminance' is introduced. More will be added as
> drivers are ported to use this new class.
>
> Amit Kucheria (1):
>  als: add unique device-ids to the als device class
>
> Zhang Rui (1):
>  introduce ALS sysfs class
>
>  Documentation/ABI/testing/sysfs-class-als |    9 ++
>  MAINTAINERS                               |    6 ++
>  drivers/Kconfig                           |    2 +
>  drivers/Makefile                          |    1 +
>  drivers/als/Kconfig                       |   10 +++
>  drivers/als/Makefile                      |    5 +
>  drivers/als/als_sys.c                     |  116 +++++++++++++++++++++++++++++
>  include/linux/als_sys.h                   |   35 +++++++++
>  8 files changed, 184 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-als
>  create mode 100644 drivers/als/Kconfig
>  create mode 100644 drivers/als/Makefile
>  create mode 100644 drivers/als/als_sys.c
>  create mode 100644 include/linux/als_sys.h
>

(Bump)

Is there any blocker to adding this for 2.6.33? Which maintainer will
pick up the ALS framework?

Rui, do you have an updated patch for the ACPI ALS driver?

Regards,
Amit

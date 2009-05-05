Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbZEELAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbZEELAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZEELA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:00:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZEELA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:00:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] of_serial: remove driver_data direct access of struct device
Date: Tue, 5 May 2009 13:00:17 +0200
User-Agent: KMail/1.9.9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>, Matthias Fuchs <mfuchs@ma-fu.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20090504201323.GA23069@kroah.com>
In-Reply-To: <20090504201323.GA23069@kroah.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051300.18614.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+hv3JZSIebN+oIqHdSyUlh+pGJCUIkfzt4aDT
 ohW+0vToTvPVuzpwIJmkPQG9HQHZ7IiTicWj3loN4HgK0dGuqb
 /meoysEgANWPBbhIRO6xA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 May 2009, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> In the near future, the driver core is going to not allow direct access
> to the driver_data pointer in struct device.  Instead, the functions
> dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> have been around since the beginning, so are backwards compatible with
> all older kernel versions.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Matthias Fuchs <mfuchs@ma-fu.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752307AbXBYE2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbXBYE2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 23:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbXBYE2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 23:28:46 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:10733 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbXBYE2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 23:28:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aKiNnZziX435j/xC6dIFquwWrrlpbibPmHAztnuT5Ay1KyTG8/1hvkdvWMPmNPOkMQtS44csDfelrpB+ux+cVvD7A+MeqHh2qNy0eVRJ8Vodk/CBzX0C2rov7VQfHMdimVDNCRki1mU4b/WiNxYFBOqgzKAkq1tu4xVDO9ZgxP8=
Message-ID: <45E1107A.2040708@gmail.com>
Date: Sun, 25 Feb 2007 13:28:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>,
       Alan <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-git10 (and -git13): BUG at drivers/pci/pci.c:817 during
 resume from disk
References: <200702150016.24865.rjw@sisk.pl> <200702151223.44846.rjw@sisk.pl> <200702171100.39114.rjw@sisk.pl> <45DA6E6D.5030700@gmail.com> <20070224230259.GU12392@stusta.de>
In-Reply-To: <20070224230259.GU12392@stusta.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Adrian.

Adrian Bunk wrote:
> On Tue, Feb 20, 2007 at 12:43:41PM +0900, Tejun Heo wrote:
>> Rafael J. Wysocki wrote:
>>> Update:
>>>
>>> I get the same BUG with 2.6.20-git13 100% of the time during the resume.
>>> The system seems to be fully functional nonetheless.
>> Known bug, will be fixed soon.
> 
> Is this a variation of
> 
> Subject    : HP nx6325: usb mouse stops working after resume from ram
> References : http://lkml.org/lkml/2007/2/21/413
> Submitter  : Arkadiusz Miskiewicz <arekm@maven.pl>
> Caused-By  : Konstantin Karasyov <konstantin.a.karasyov@intel.com>
>              commit 0a6139027f3986162233adc17285151e78b39cac
> Status     : unknown
> 
> or one of the other ACPI problems in 2.6.21-rc1?

No, it's not related to ACPI.  It's caused by devres changes and fixed
in libata-dev tree.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbYFOIPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbYFOIPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 04:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYFOIP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 04:15:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:33826 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbYFOIPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 04:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OG8I/jOUKGBKAvvXtcXjFpiO/SV8pL2LaYKtfKmUCsRD6dioGqzeL+6WANbrl2pXEk
         2uiRC7otfDHmr2a9YJ1uRY70Axwxuzz9uE5nyuIC7RfpSy0A8WAXo7Z3Mv0pQRkmkERQ
         u4oDmgwwzfTnEE7PJwcUYpVDHoBjiOdH1BbUo=
Message-ID: <a5bf86a80806150115q2d3ee545y84bae48f84d4fe96@mail.gmail.com>
Date: Sun, 15 Jun 2008 11:15:23 +0300
From: "Lior Dotan" <liodot@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [Bug 10866] /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       a.zummo@towertech.it,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, rtc-linux@googlegroups.com
In-Reply-To: <20080613212023.GB1716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dCRO4tbfLzK.A.rFC.L2vSIB@albercik>
	 <20080613193302.GA1716@cs181133002.pp.htv.fi>
	 <a5bf86a80806131255w704745d7mc109c13669ac9c68@mail.gmail.com>
	 <20080613212023.GB1716@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 12:20 AM, Adrian Bunk <bunk@kernel.org> wrote:
>
> What is the output of "grep RTC_ .config" on your old .config?

Here it is:

# CONFIG_HPET_RTC_IRQ is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

Do note that my 2.6.25 kernel was from Gentoo but none of the patches
there seem related to RTC.

Lior.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbZABNiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbZABNiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 08:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZABNhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 08:37:54 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:37225 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZABNhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:37:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=k2yaocXOnMm+B9o9kS88L6dRujQgTLT8RBVX12pgrre/bRN9aS3GnZJsduxHUPmW6j
         6EGb9jNCqyhRhkqEMNx+ZJR8G59Zfpsa/C5h4xXPK5Kis3/bP6SO9LcvvajATg1j3/5s
         R/IEpVpGfK1sd+tb+7QPw8TU+J+sUJmCqJ3iY=
Date: Fri, 2 Jan 2009 21:37:44 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
	be   unplugged safely
Message-ID: <20090102133744.GB4833@thyme.bj.intel.com>
Mail-Followup-To: "Alexander E. Patrakov" <patrakov@gmail.com>,
	gregkh@suse.de, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090101160343.GA4278@thyme.bj.intel.com> <495CFE38.6070603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495CFE38.6070603@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 10:32:40PM +0500, Alexander E. Patrakov wrote:
> Yan Li wrote:
>> On Windows and Mac OS, `safely remove this device' function effectly
>> turns it into `suspend' mode, and it's light off.
>
> You have obviously tested only Windows XP, because Vista doesn't cut the  
> power for at least some USB devices. And congratulations for obtaining a  
> Vista-incompatible hard drive (of course, joking).

To be honest I tested neither Windows, I just picked up other Linux
user's complaints (pretty much online) who are using both Windows and
Linux and thus can compare.

Curiously, is this change in behavior btw XP and Vista another blunder
MSFT made?

> BTW, does the "eject /dev/$DEV" command help?

Nope. Unlike iPOD this device doesn't honor eject.

-- 
Li, Yan

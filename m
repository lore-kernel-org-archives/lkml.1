Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYBEO0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYBEO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 09:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYBEO0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 09:26:42 -0500
Received: from serenity.mcc.ac.uk ([130.88.200.93]:54751 "EHLO
	serenity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYBEO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 09:26:42 -0500
Message-ID: <47A87236.4000204@gentoo.org>
Date: Tue, 05 Feb 2008 14:27:02 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071117)
MIME-Version: 1.0
To: lists@ku-gbr.de
CC: Xavier Bestel <xavier.bestel@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/1] Nikon D80 usb-storage quirk needs modified, new FW
References: <20080205124343.GB6638@anita> <1202218008.23816.9.camel@skunk.anacadf.mentorg.com> <20080205141841.GA6791@anita>
In-Reply-To: <20080205141841.GA6791@anita>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kletschke wrote:
> Am 2008-02-05 14:26 +0100 schrieb Xavier Bestel:
> 
>>> +UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
> 
>> Maybe you should leave them both here.
> 
> I suppose the device is checked against a range between
> bcdDeviceMin -> bcdDeviceMax to take care of the possibility new
> revisions does not need the quirk anymore but all older and bcdDeviceMax
> but I found the piece of code not yet. Lets see...

You're correct, the patch is fine in that respect. However
it is whitespace-corrupted and hence will not apply. You should also 
submit it directly to the usb-storage maintainer with the linux-usb (and 
maybe the usb-storage) list on CC.

Daniel


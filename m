Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZKNQIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZKNQIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 11:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZKNQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 11:08:49 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:44855 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZKNQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 11:08:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sKIy9e2q2/1tU7Ly+Tnylo77uA/UXSm3BAXo0EbiCQ+oQ54XWZaY52fFypIJqLKQHj
         A5RqziUgTG1lPrKgEuPkhsVkbu3DaiaIHIc2+rY0MqCG22t58TDqdcNR9oV7IB3p3RRa
         eL4dOtSPlpEOVPe36VAg9yGUfSyHEMDlTqcKw=
Message-ID: <4AFED614.1050109@gmail.com>
Date: Sat, 14 Nov 2009 10:08:52 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Philip Downer <phil@csldevices.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: firmware loading interface
References: <4AFD971C.3090204@csldevices.co.uk>	<4AFD9BAF.1010200@csldevices.co.uk> <aday6mac5ai.fsf@roland-alpha.cisco.com>
In-Reply-To: <aday6mac5ai.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 06:35 PM, Roland Dreier wrote:
>
>   >  However our device will have flash to store the firmware in and, whilst
>   >  it looks as though it would be possible for us to use request_firmware
>   >  to provide occasional firmware upgrades from userspace, I can't find any
>   >  reference as to whether this is an accepted method for doing so. Could
>   >  someone please confirm for me whether or not it's a good idea to use
>   >  request_firmware for this, or perhaps point me at another standard
>   >  method for doing firmware updates from userspace?
>
> I think request_firmware() is fine for this... you could have a look at
> drivers/net/cxgb3 to see a device that writes new firmware to flash when
> it detects a version mismatch between driver and device.

It depends on the consequences of a failed flash due to losing power, 
crash, etc - if it has the potential to brick the device then I don't 
think that should happen without the user triggering it explicitly..

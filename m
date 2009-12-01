Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZLAJOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZLAJOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbZLAJOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:14:34 -0500
Received: from mail-px0-f173.google.com ([209.85.216.173]:40032 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbZLAJOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:14:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JFZLfL0XfGCcwwG5WOVbn/6vd4xM/hhd33cZp2WYS2EtkbWsO0D8gUTPgrbSkasnOR
         YhIn69YyKyvjB6Gii6huzJKJ6+iVQbC8Iw5dVVEtZWPo7x0tYIKWIepJZd6R6pNfTEsD
         Dm59Q+5fOKKht6r2gYc95QfGN9vNJIbqlv5ds=
Date: Tue, 1 Dec 2009 01:14:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Philip Downer <phil@csldevices.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: firmware loading interface
Message-ID: <20091201091435.GB16910@core.coreip.homeip.net>
References: <4AFD971C.3090204@csldevices.co.uk> <4AFD9BAF.1010200@csldevices.co.uk> <aday6mac5ai.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aday6mac5ai.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 04:35:01PM -0800, Roland Dreier wrote:
> 
>  > However our device will have flash to store the firmware in and, whilst
>  > it looks as though it would be possible for us to use request_firmware
>  > to provide occasional firmware upgrades from userspace, I can't find any
>  > reference as to whether this is an accepted method for doing so. Could
>  > someone please confirm for me whether or not it's a good idea to use
>  > request_firmware for this, or perhaps point me at another standard
>  > method for doing firmware updates from userspace?
> 
> I think request_firmware() is fine for this... you could have a look at
> drivers/net/cxgb3 to see a device that writes new firmware to flash when
> it detects a version mismatch between driver and device.
> 

Doesn't dell_rbu also uses request-firmware for flashing BIOS?

-- 
Dmitry

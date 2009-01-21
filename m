Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbZAUPXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbZAUPXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZAUPWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:22:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:18945 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbZAUPWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VmSLOdix11Y0QSDX8QRKD4E3We6QS47MBdRpNxGvDFQNj8NldagS5NtfUZ81uWblON
         yXAWu83L/8smCogcPWosNiGEnIvuX8iZ2Fa17PL8LfzTnAXIFL5aYv24iNMLFihRB+Hl
         lNTpqWHBcgCeyUQvwk2x9KZDnUvnm9fu062H0=
Date: Wed, 21 Jan 2009 18:28:18 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] tg3 module problem on Linux-2.6.29-rc1-2
Message-ID: <20090121152818.GA3438@x200.localdomain>
References: <49771D65.3090205@turknet.net.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49771D65.3090205@turknet.net.tr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 03:04:37PM +0200, Tarkan Erimer wrote:
> I built kernel packages for 2.6.29-rc1 and rc2 on Kubuntu 8.10. When  
> installing these built kernel .deb packages, it points to this warning  
> message. Booting with these kernels gives no network connection. Both of  
> these RC kernels and git snapshots have the same problem. The same  
> ".config" works fine with older kernels.
>
>
> Using mkinitramfs-kpkg to build the ramdisk.                              
>                                W: Possible missing firmware  
> /lib/firmware/2.6.29-rc2-git1/tigon/tg3_tso5.bin for module tg3           
>   W: Possible missing firmware  
> /lib/firmware/2.6.29-rc2-git1/tigon/tg3_tso.bin for module tg3            
>   W: Possible missing firmware 
> /lib/firmware/2.6.29-rc2-git1/tigon/tg3.bin for module tg3

> # CONFIG_FIRMWARE_IN_KERNEL is not set

Try setting this option to =y.

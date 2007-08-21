Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbXHUTYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbXHUTYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXHUTYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:24:37 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42090 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755054AbXHUTYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:24:36 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: "Hex Star" <hexstar@gmail.com>
Subject: Re: Trouble booting with new 2.6.22.3 kernel
Date: Tue, 21 Aug 2007 22:25:51 +0300
User-Agent: KMail/1.9.7
References: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com>
In-Reply-To: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708212225.51987.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2007 22:19:13 you wrote:
> Hello, I am running Kubuntu 7.04 on a mac mini (specs attached via
> info.html). For learning purposes I am trying to custom build a
> 2.6.22.3 kernel from source and boot from it. My plan was to use the
> distributions .config file (and I specified the settings for options
> that were added since the last kernel included with Kubuntu which is
> (and is what I have now reverted to) Linux hexstar-desktop
> 2.6.20-16-generic #2 SMP Thu Jun 7 20:19:32 UTC 2007 i686 GNU/Linux).
> I have attached the .config file used in the building of the 2.6.22.3
> kernel. Below is the error:
>
> Starting up...
> Uncompressing Linux... Ok, booting the kernel.
> [ 32.227452] i8042.c: No controller found
> [ 32.228426] Kernel panic - not syncing: VFS: Unable to mount root fs
> on unknown-block(0,0)
>
> That is the correct block however and it is of ext3 format. I have
> made sure that the ext3 module is built into the kernel and have tried
> it as a module and both times I get the same error. I am not sure why
> it can't find the controller? Does my controller not have support in
> the latest kernel?
>
> Please CC me replies to this post, thanks! :)

Make sure your IDE/SATA driver is compiled in unless you are using an 
initramfs image.

Regards,
ismail

-- 
Perfect is the enemy of good

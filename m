Return-Path: <linux-kernel-owner+w=401wt.eu-S1751587AbZL0KA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbZL0KA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 05:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZL0KA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 05:00:27 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:50144 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZL0KA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 05:00:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RaCcU9QSK277qJWkD0Wora/oQXmOw6ECnDbQwDnLOpowYKa9Orkj6w4NP/sED11OgY
         HHFFPs1ZkczKYS6zZvGSgBdm7K7zp+U8qC+qobybEsrg7dOthgf1uRmSoyhLqmOO+ms0
         f6+GApPdhWo0E8/bAdFP5u3ktd7FFxZC5tN4M=
Date: Sun, 27 Dec 2009 02:00:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: okias <d.okias@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc2 allergic to amanda?
Message-ID: <20091227100020.GB14655@core.coreip.homeip.net>
References: <c2673ca60912261049i6539b54ci6663bc60dde8d096@mail.gmail.com>
 <c2673ca60912261051q40049708j7e9de0b34f7a1a13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2673ca60912261051q40049708j7e9de0b34f7a1a13@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 07:51:57PM +0100, okias wrote:
> Same problem after "sync" on /boot partition ext2 mounted by ext4 (new
> option in Kconfig)
> 
> /dev/sda1 on /boot type ext2 (rw,noatime)
> 

Happens to me too.. It looks like using ext4 for non-ext4 partitions is
not good for your health at the moment. The BUG() goes away as soon as I
enable proper ext3 driver.

-- 
Dmitry

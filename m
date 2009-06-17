Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbZFQRCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbZFQRCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZFQRBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:01:54 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:58686 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZFQRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:01:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=qBt8KTHiSCnlRzd6TqOcPK4gzgpUTuyxw4sBd6SmTprfEQ7aDB5+/T1dCf3XksEJB1
         e2IFc0gT7/BLHV1R9wmUrGj8IuEY1JJPGlNBzCfqgRY6F5KEDjLhkQwcxySxl9F8M7M2
         DVdhBkN/nn2JBE+IgpSoyAg4hBSets3Efve+0=
Message-ID: <4A39208C.3010801@gmail.com>
Date: Wed, 17 Jun 2009 18:57:48 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: Re: [PATCH 14/14] Pramfs: XIP Operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> > I know. It wasn't my intention to introduce it but as I said in my
> > first patch I've done a porting of this code from 2.6.10 and to
> > remove it I need time to analyze well the code to avoid deadlock and
> > so on. If someone would like to help me I'd really appreciate it.
> > However I see the use of BKL even in other recent "mainlined" fs as
> > ext4, so I preferred to move the porting effort on other areas.
> > However it's the first item on my todo list.

> Why do you need the lock in pram_find_and_alloc_blocks() to begin
> with?  Why wouldn't a mutex work?

It's not impossible to use a mutex, but as I said it's inherited from
code written for 2.6.10. This function works as
pram_get_and_update_block works.

Marco

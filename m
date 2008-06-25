Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYFYMD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYFYMD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYFYMDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:03:46 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:6161 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbYFYMDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rf59SidCEIxKUMxjwJNh3J76BVawrdNNtkM7KfG5sUrMORgJCmu/ooFTHPzIRt6xTe
         RaoR7oomz9bB011FStZqBs2FYzGIHXRGmTj2C6dJSrdp2BSl4HA+hi8hYKU1p2KNX8yZ
         JEqyRm1+mCPiRTnhmEqKeuG4KSb3oxe/CM8UQ=
Message-ID: <48623411.1030104@gmail.com>
Date: Wed, 25 Jun 2008 21:03:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org,
       bzolnier@gmail.com, linux-ide@vger.kernel.org
Subject: Re: [regression] Re: 2.6.26-rc6: pcmcia stopped working
References: <20080622224022.GA2066@elf.ucw.cz> <20080623081309.GA10820@isilmar.linta.de> <20080623081811.GA1850@elf.ucw.cz> <20080623083046.GA12849@isilmar.linta.de> <20080625102347.GA2011@elf.ucw.cz> <20080625110105.GA1551@elf.ucw.cz>
In-Reply-To: <20080625110105.GA1551@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pavel.

Pavel Machek wrote:
> pccardd       D f6dd1e1c     0  1121      2
>        f6dd1e30 00000086 00000002 f6dd1e1c f6dd1e10 00000000 c2015e80 c2015e80 
>        c09113e0 00000286 00000286 f72d13b8 f72d1618 c2015e80 f6dd0000 f6afedc0 
>        ffff03a9 f6bcb458 00000000 c02bd187 00000000 f6dd1e4c 00000003 00000000 
> Call Trace:
>  [<c02bd187>] sysfs_addrm_finish+0x1a7/0x1e0
>  [<c072edec>] schedule_timeout+0x7c/0xd0
>  [<c02bd1e7>] remove_dir+0x27/0x40

Strange.  sysfs_addrm_finish() releases resources and is unlikely to
block.  Can you please translate the PC to source line?

Thanks.

-- 
tejun

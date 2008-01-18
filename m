Return-Path: <linux-kernel-owner+w=401wt.eu-S1760384AbYARMa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbYARMa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbYARMaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:30:52 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:61247 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbYARMav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:30:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=w1Xa+wrkbxpQIRK29WnBxBLOEm72flBlQSwoGU123dSlBdf3qxgMbpb16vvXTfUh0Eamg2H5p4Y9yCibx/rbx7Cwz8sURnk+o6xS66n65AyBcxl6veupzH9CEJLYaPaDUJEH9G8Ny5DBAzf5fn7jPJlCM3VRw0k5g3kCkzHvgFA=
Date: Fri, 18 Jan 2008 20:29:17 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sam@ravnborg.org
Subject: Re: build #343 issue for v2.6.24-rc8-29-g03bbe08 : Section
	mismatch: reference to .init.text.1:start_kernel (between 'is386'
	and 'check_x87')
Message-ID: <20080118122917.GH2559@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200801181318.30009.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801181318.30009.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 01:18:27PM +0100, Toralf Förster wrote:
>Hello,
>
>the build with the attached .config was successful however I got during make :
>  AS      .tmp_kallsyms2.o
>  LD      vmlinux.o
>  MODPOST vmlinux.o
>WARNING: vmlinux.o(.text.head+0x247): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')
>  CHK     include/linux/version.h
>  HOSTCC  scripts/unifdef
>  MKDIR   include
>
>Does it help / make sense to report such warning ?
>
>The build was made with :
>$> make mrproper && make rndconfig && <tweak config file> && make oldconfig && make
>
>Here's the config:

Thanks. You have reported this. ;)

I can't solve this problem. Let's Cc Rusty and Sam to see
if they can solve this.

Regards.


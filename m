Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYKVRXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYKVRXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbYKVRXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:23:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:41831 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758660AbYKVRXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:23:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UspkqmLbAjEVZfE3cOJ7rAqKEjgx8O+MNPNyO3/ubFUzElykcj3qr9ea2wxpz6owb9
         13FdaG5g386XnOuASh3cbWjC7Q4ftYB8LN4ibGvymP8c81NHOUjkz0L4rtgKoN3Z2Y8l
         nvgyJ0XYanuZ8mna9xvgmr7JHT47xkuhXCd+I=
Date: Sat, 22 Nov 2008 20:27:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] sysrq-j: emergency shell
Message-ID: <20081122172702.GB2748@x200.localdomain>
References: <20081121235159.GA15861@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121235159.GA15861@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 12:51:59AM +0100, Vegard Nossum wrote:
> This patch adds support for "SysRq-j", which invokes an emergency
> root shell in the current console.
> 
> Please don't bite my head off for abusing the file API; documentation
> was rather sparse! (Corrections are welcome, though.)
> 
> It seems that keyboard input will go to the shell only half of the
> time; the other half goes to whatever program was running there in
> the first place. I tried to kill the other users of the TTY using
> TIOCSCTTY, but it seems not to have worked. Any ideas?

This should go in together with CVE number attached.

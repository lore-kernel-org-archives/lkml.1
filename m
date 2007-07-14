Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbXGNH2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbXGNH2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXGNH2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:28:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:41159 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXGNH2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=s4aUDjeh9y0+6caYWqyT5PwZZikys+sAeVWmSgYh/sPqshy4k4FZo1bQR4k1sQ/N2MG6E4VsxZrWU+hj83Ws7jUpXK/RvQEUtYRodCVq5NWzr5lYpHjPwVgA6uHZMpvs4cQj6NpVLN8f7enre9y3dVJ4FcaoWzorWnEZeUxbDKI=
Date: Sat, 14 Jul 2007 11:28:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 4/8] Immediate Value - Add kconfig menus
Message-ID: <20070714072801.GB5822@martell.zuzino.mipt.ru>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.839969254@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070714012623.839969254@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 09:24:43PM -0400, Mathieu Desnoyers wrote:
> Immediate values provide a way to use dynamic code patching to update variables
> sitting within the instruction stream. It saves caches lines normally used by
> static read mostly variables.

>  kernel/Kconfig.immediate |   11 +++++++++++

NAK, if this immediate stuff is so super-cool¹ it should be default on.

¹ it isn't


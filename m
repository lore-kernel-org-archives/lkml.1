Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbZJ1H7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbZJ1H7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932628AbZJ1H7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:59:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47608 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608AbZJ1H7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:59:06 -0400
Date: Wed, 28 Oct 2009 08:59:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
Message-ID: <20091028075908.GO7744@basil.fritz.box>
References: <20091027.222814.137568780.davem@davemloft.net> <alpine.DEB.2.00.0910280539150.19088@skynet.skynet.ie> <20091027.230450.222178419.davem@davemloft.net> <20091028.005342.60092591.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028.005342.60092591.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	}
> -	chunk_array_ptr = (uint64_t *)(unsigned long)(cs->chunks);
> +#ifdef CONFIG_COMPAT
> +	if (is_compat_task())

Are the COMPAT ifdefs really needed? The compiler should optimize that
away anyways on non compat aware architectures, shouldn't it?

-Andi


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbXFMRH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbXFMRH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758457AbXFMRHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:07:20 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:47957 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758319AbXFMRHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ccfWRCwi+vzAeNd3R2pqAN+jXZyqUd6+lJnEi7d1bJqMF4nqKkjXBcoho7TBvkSxVd96F12kt7AaC8+hdtxU2uEzDMkoM4jgmC34P06WY2VMIT3FZ9cfY1DZ7fSTbDzx7B2yjL0BRzH4rH8ZRsT3UiT/j266NT6upK5XGkwW7vU=
Date: Wed, 13 Jun 2007 21:16:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: holzheu <holzheu@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       gregkh@suse.de, mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070613171628.GA5721@martell.zuzino.mipt.ru>
References: <1181747217.29512.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181747217.29512.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 05:06:57PM +0200, holzheu wrote:
> -CHECK		= sparse
> -
> -CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise $(CF)
> +CHECK		= scripts/kmsg-doc check
> +CHECKFLAGS	=

Ick. Don't touch those checking kernel with sparse.


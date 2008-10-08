Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYJHN7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYJHN7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 09:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYJHN7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 09:59:33 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:16840 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbYJHN7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 09:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eAYRn8lsad0mYI3AFHiEoxIsKYqcOPYRod/hy5H/znuJ03HbUCIMElxLrvkQMuwzq/
         SS6ndoaWdOFRzRoS7n7FzzQ3tKHVESmo9hqgW7gRkQThctXUg2arYhLdU81R5ZR+mC7w
         r+6XUrazSxt+Zpxv0Mb5jr8PLhpCmP07UcxkI=
Date: Wed, 8 Oct 2008 18:02:14 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] h8300: Change unaligned access to use packed
	struct implementation
Message-ID: <20081008140214.GC2739@x200.localdomain>
References: <1223447903.8195.65.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223447903.8195.65.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 11:38:22PM -0700, Harvey Harrison wrote:
> There are only 3 arches that use the memmove-based implementation, there
> doesn't seem to be any obvious reason not to use the struct implementation.

1. Extensive use of "--- " area means changelogs are written badly.
2. Changing one of arch core header we can deduce from patch and this
   exactly what subject line says.
3. As such there is absolutely no changelog.

[goes into digging how all this byteorder and endian activity was
started]

> --- a/arch/h8300/include/asm/unaligned.h
> +++ b/arch/h8300/include/asm/unaligned.h

> -#include <linux/unaligned/be_memmove.h>
> +#include <linux/unaligned/be_struct.h>

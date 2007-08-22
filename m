Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbXHVPxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbXHVPxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbXHVPxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:53:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:42076 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbXHVPxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rU8sWnzaMlxbhACBtw1mBF3VhafeHWzQaFKBTZ1+84p/OTy/B3Rmt8MfLtnQ/uncQ/wmBYIeoLCWNsWtmoA/+OM/6ENW3TgKTSFIQMSedFQPG8WuJQwpQPSOl4/SxtABykzY8wfWgpHMIabBdAnSSJjOk2A5uWc5KB7RtrLDj+w=
Message-ID: <a4e6962a0708220853n7689985fj71ba19b67e17ae5d@mail.gmail.com>
Date: Wed, 22 Aug 2007 10:53:02 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [2.6.20.17 review 32/58] fs: 9p/conv.c error path fix
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <20070822084023.%N@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822083844.%N@1wt.eu> <20070822084023.%N@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/07, Willy Tarreau <w@1wt.eu> wrote:
> When buf_check_overflow() returns != 0 we will hit kfree(ERR_PTR(err))
> and it will not be happy about it.
>
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
Acked-by: Eric Van Hensbergen <ericvh@gmail.com>

This seems to be in the current code as well, I'll forward-port the patch...

                    -eric

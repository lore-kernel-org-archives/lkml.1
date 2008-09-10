Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbYIJMNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbYIJMNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYIJMNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:13:05 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:63704 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbYIJMNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DmyngY1L3xwAbs6tPF3wFK4ux/gJRnli6QX76BDlDhGJ+U9ZrZiIRN1Fk8P2wjn+S/
         bfDvkqVD99N0aisY+G5kLT6zbzbNfmhJ+gXaGPEdUM7OZOaxcbYpoIHnql/0J6kPCI8N
         edNkezbsPKldgKC9kSV8sMxBRLkWPT9JvEYik=
Date: Wed, 10 Sep 2008 16:14:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <caulfie@redhat.com>,
       David Teigland <teigland@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] include <linux/types.h> into linux/dlm_plock.h for
	__u* typedef
Message-ID: <20080910121450.GA3468@x200.localdomain>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <1221045726-5674-2-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221045726-5674-2-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 02:22:04PM +0300, Kirill A. Shutemov wrote:
> --- a/include/linux/dlm_plock.h
> +++ b/include/linux/dlm_plock.h

> +#include <linux/types.h>

I'd say that unless you can demonstrate compilation breakage, these will
only slow down compilation.

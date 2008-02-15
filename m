Return-Path: <linux-kernel-owner+w=401wt.eu-S1763406AbYBOUfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763406AbYBOUfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbYBOUfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:35:42 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:12199 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760697AbYBOUfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:35:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cd+KNROELpkbcXqc5zHmBKmuT8pEJnQiOrEyy5h7YE9BV7B2GuNTONVOC2IN20PNGp85LFEXVlLjHJV62ynpviWj8+hRCf8c9zwy0aTJ793NLBC2KmD0IwifHTfpg5UObNpoVWwp+f/2O/CYVzorSl+7pJJ+lyRMnUe2vKFJszc=
Subject: Re: [patch] fuse: fix permission checking
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <E1JPxjP-0004sQ-5O@pomaz-ex.szeredi.hu>
References: <E1JPxjP-0004sQ-5O@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 12:35:38 -0800
Message-Id: <1203107738.15275.39.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 11:23 +0100, Miklos Szeredi wrote:
> This is for 2.6.25 and 2.6.24.y, but NOT for 2.6.23.y.
> 
> Thanks,
> Miklos
> ----
> 
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> I added a nasty local variable shadowing bug to fuse in 2.6.24, with
> the result, that the 'default_permissions' mount option is basically
> ignored.
> 
> How did this happen?
> 
>  - old err declaration in inner scope
>  - new err getting declared in outer scope
>  - 'return err' from inner scope getting removed
>  - old declaration not being noticed
> 
> -Wshadow would have saved us, but it doesn't seem practical for
> the kernel :(
> 
> More testing would have also saved us :((

sparse would have saved you too.

Harvey


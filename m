Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbYIIXfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbYIIXfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbYIIXfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:35:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:53006 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbYIIXfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x87XpUIzUHktbsNCbDCa2FNydAX9vFNSMlNNKZin6qVYwdwAAcyLepmRe9cLWVGhoI
         hy0R+dL96TD5puWBjxCW9xwoYHgSxG1oynKh8fTNsHeVe1LroXIi4LCp/Zq1cI5bmcZy
         vKNRppwfACGVj94wiQp/H4I7YSbjHYg9Bjomc=
Message-ID: <f7848160809091635n52d57675s65f4db31b3a9ba20@mail.gmail.com>
Date: Tue, 9 Sep 2008 19:35:22 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: sysfs - kill owner field from attribute
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, htejun@gmail.com,
       gregkh@suse.de
In-Reply-To: <20080909162602.e45970ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com>
	 <20080909162602.e45970ec.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 7:26 PM, Andrew Morton <akpm@linux-foundation.org> wrote:

> The patch was wordwrapped - please fix that up before sending any more
> patches.

Yep, sorry. Fighting with git-send-email right now - once I win
hopefully there will be no more trouble.

> This is simpler, no?

Yes, of course. Thanks.

>
> --- a/include/linux/sysfs.h~x86-sysfs-kill-owner-field-from-attribute-fix
> +++ a/include/linux/sysfs.h
> @@ -27,7 +27,7 @@ struct module;
>  */
>  struct attribute {
>        const char              *name;
> -#if !defined(CONFIG_X86_64) && !defined(CONFIG_X86_32)
> +#ifndef CONFIG_X86
>        struct module           *owner;
>  #endif
>        mode_t                  mode;

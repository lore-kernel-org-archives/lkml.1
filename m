Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZKWQJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZKWQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbZKWQJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:09:28 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:58356 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbZKWQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:09:28 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 11:09:27 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DiXqf6Egx9hMTVsuT1pwdsrj8QJWEyK/mUwg9mY6Rp2/E1jgu6MFk3O0sjHoS5Vu9n
         YIMDnYfHGjaHhWzzosV9lcEOxKN+8FVE/3Blf1i5bJrnx0WGwj2CLbprGV3GkKxsRoZs
         cJmW9nNkw+VGbE1A2jNUMhccY0j7PLqIT0Hm8=
Date: Tue, 24 Nov 2009 00:04:24 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, stefani@seibold.net
Subject: Re: [PATCH] tags: put function prototypes back (like in 2.6.31)
Message-ID: <20091123160424.GH2412@hack>
References: <20091121175058.GA2904@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091121175058.GA2904@x200.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 08:50:58PM +0300, Alexey Dobriyan wrote:
>Having function prototypes in tags is useful for e.g. quick look
>which header is needed for compile fix.
>

Sounds reasonable, but this will make finding the definition
a little harder with cscope, since usually I get more than
just the definition when I just want to locate it with cscope.

Thanks.


>removed in commit 7db86dc97fb0c47af63e6b965e8ff37126050d25
>"ctags: usability fix"
>
>Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>---
>
> scripts/tags.sh |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>--- a/scripts/tags.sh
>+++ b/scripts/tags.sh
>@@ -102,7 +102,7 @@ exuberant()
> 	-I ____cacheline_internodealigned_in_smp                \
> 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
> 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
>-	--extra=+f --c-kinds=-px                                \
>+	--extra=+f --c-kinds=+px                                \
> 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
> 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
> 
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 

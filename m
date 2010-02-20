Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab0BTPck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:32:40 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:40422 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab0BTPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:32:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qgzzI8j2V7AHXt5zRwzsxB2871RyYC1Rf+Bew9xg9a82K1SU4go6w7S/LM/VDytPhB
         FBsIMxcjqD8hygsKjofNbbgrJQATmvkZxSYmZ/ZwdH3s6aLsDtSMs0qAqdwA9q3kfifB
         Xibp5s0boJObFmuqqu39Z1DjZ1XKTp1E4cCzw=
Date: Sat, 20 Feb 2010 23:35:21 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] um: tell git to ignore generated files
Message-ID: <20100220153521.GK3000@hack>
References: <20100220143359.GD3000@hack> <20100220150936.GP30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100220150936.GP30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 03:09:36PM +0000, Al Viro wrote:
>On Sat, Feb 20, 2010 at 10:33:59PM +0800, Am??rico Wang wrote:
>> 
>> git should ignore these files, since they are generated.
>
>> +include/shared/kern_constants.h
>> +include/shared/user_constants.h
>
>I have patches taking that to include/generated, actually

Oh, ok, I can remove these two for you. :)

Thanks.


------------>

Tell git to ignore the generated files under um, except:

include/shared/kern_constants.h
include/shared/user_constants.h

which will be moved to include/generated.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>


---
diff --git a/.gitignore b/.gitignore
index de6344e..efab0eb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -36,6 +36,7 @@ modules.builtin
 #
 tags
 TAGS
+linux
 vmlinux
 vmlinuz
 System.map
diff --git a/arch/um/.gitignore b/arch/um/.gitignore
new file mode 100644
index 0000000..f22bd73
--- /dev/null
+++ b/arch/um/.gitignore
@@ -0,0 +1,3 @@
+kernel/config.c
+kernel/config.tmp
+kernel/vmlinux.lds


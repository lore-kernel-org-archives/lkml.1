Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbXHLFDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbXHLFDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 01:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXHLFDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 01:03:36 -0400
Received: from xenotime.net ([66.160.160.81]:42994 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751030AbXHLFDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 01:03:35 -0400
Date: Sat, 11 Aug 2007 22:09:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: vincent.legoll@gmail.com
Cc: zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Add "def_bool" Kconfig format documentation
Message-Id: <20070811220928.b079d2e5.rdunlap@xenotime.net>
In-Reply-To: <1186439380.21014.9.camel@quad>
References: <1186439380.21014.9.camel@quad>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 00:29:40 +0200 Vincent Legoll wrote:

> Hello,
> 
> here is a small documentation patch for the KConfig file format
> "def_bool" type definition that was missing.

There are also def_boolean and def_tristate.
I suppose that I should resubmit this patch:
  http://marc.info/?l=linux-kernel&m=115471883121076&w=2


> I hope the patch is not mangled...
> 
> >From 4742eb7a3169001304524e82a88ec1c94f70aa56 Mon Sep 17 00:00:00 2001
> From: Vincent Legoll <vincent.legoll@gmail.com>
> Date: Sat, 4 Aug 2007 16:50:06 +0200
> Subject: [PATCH] - Add "def_bool" Kconfig format documentation
> 
> 
> Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
> ---
>  Documentation/kbuild/kconfig-language.txt |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
> index 536d5bf..27b8af9 100644
> --- a/Documentation/kbuild/kconfig-language.txt
> +++ b/Documentation/kbuild/kconfig-language.txt
> @@ -77,6 +77,14 @@ applicable everywhere (see syntax).
>    Optionally, dependencies only for this default value can be added
> with
>    "if".
>  
> +- boolean type definition with a default value: "def_bool" <expr>
> +  So these two examples are equivalent:
> +  
> +    def_bool <expr>
> +  and
> +    bool
> +    default <expr>
> +  
>  - dependencies: "depends on"/"requires" <expr>
>    This defines a dependency for this menu entry. If multiple
>    dependencies are defined, they are connected with '&&'. Dependencies
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

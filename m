Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbXDKUVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbXDKUVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965271AbXDKUVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:21:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59197 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030470AbXDKUVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:21:07 -0400
Date: Wed, 11 Apr 2007 13:20:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <corentincj@iksaif.net>,
       <sziwan@users.sourceforge.net>, <acpi4asus-user@lists.sourceforge.net>,
       <len.brown@intel.com>, <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
Message-Id: <20070411132053.899462b4.akpm@linux-foundation.org>
In-Reply-To: <2189310342910921713@karneval.cz>
References: <2189310342910921713@karneval.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 15:04:35 +0200 (CEST)
Jiri Slaby <jirislaby@gmail.com> wrote:

> @@ -706,6 +718,8 @@ static int get_lcd_state(void)
>  {
>  	int lcd = 0;
>  
> +	BUG_ON(!hotk->methods->lcd_status);

mutter.  We could just warn-and-bale here.

Hopefully this is just an is-jiri-sane assertion and it should never happen,
no matter how busted the BIOS tables are?

If it _does_ ever trigger, well, we just took out someone's machine
quite unnecessarily.

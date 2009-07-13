Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZGMXHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZGMXHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 19:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZGMXHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 19:07:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968AbZGMXHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 19:07:46 -0400
Date: Mon, 13 Jul 2009 16:06:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Feuerer <peter@piie.net>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, andi@lisas.de,
       petkovbb@googlemail.com
Subject: Re: [PATCH] Acerhdf: fix fan control for AOA150 model
Message-Id: <20090713160614.521c932a.akpm@linux-foundation.org>
In-Reply-To: <20090712232104.4f2fbf46.peter@piie.net>
References: <20090712232104.4f2fbf46.peter@piie.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009 23:21:04 +0200
Peter Feuerer <peter@piie.net> wrote:

> Hi Len,
> 
> please apply,
> 
> -- 
> 	peter
> 
> Changed:
>  o Applied Borislav Petkov's patch (convert the fancmd[] array to a real 
>    struct thus disambiguating command handling and making code more readable.)
>  o Added BIOS product to BIOS table as AOA110 and AOA150 have
>    different register values
>  o Added force_product parameter to allow forcing different
>    product
>  o fixed linker warning caused by "acerhdf_drv" not being named
>    "acerhdf_driver"
> 
> Signed-off-by: Peter Feuerer <peter@piie.net>

It looks like this work should have been presented as four separate patches.

Inclusion of Borislav's Signed-off-by: would be appropriate.

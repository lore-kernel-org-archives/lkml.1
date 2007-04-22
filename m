Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXDVGhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXDVGhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 02:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965095AbXDVGhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 02:37:42 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:22433 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965044AbXDVGhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 02:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f/lXEUZi762sj5GXvFxCFFMtFgqTASwNhHVpXEnR+VeW2ucjaNivz44ps+kDOILSXbaGtg9DTV9ZxeDeCaODZzwn+cGXZ3KnLmzaSoN+COY4q3LRtgUVpFi6FASER4JXMLO55QICu4lnY8e082auK3vhqS5VQcYOJpcsPlJzp9A=
Message-ID: <653402b90704212337o2ff44140uaa6ab1c893b2bc7f@mail.gmail.com>
Date: Sun, 22 Apr 2007 08:37:40 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 1/8] Kconfig: refine depends statements.
Cc: "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <200704220050.24089.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070420113228.GB3738@skybase> <200704220050.24089.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/07, Arnd Bergmann <arnd@arndb.de> wrote:
>
> I would guess that this actually depends on PARPORT, not PARPORT_PC.
>

In fact it does not depend on any of them. Auxiliary Displays could
use any kind of interface. However, by now we only have one controller
driver (ks0108) through parport (PC); so for the moment the patch
would be OK, although the menu "Auxiliar Displays" is not just about
parport'ed-stuff.

> The rest of this patch looks good.
>
> 	Arnd <><
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm

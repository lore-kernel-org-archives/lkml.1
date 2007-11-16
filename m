Return-Path: <linux-kernel-owner+w=401wt.eu-S933986AbXKPPPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986AbXKPPPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759341AbXKPPPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:15:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:58839 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXKPPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:15:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=coqNnUS7hi6PLszTUeEJ9JCF2PEed/H+y1h4OoGkYtVy3hIfdlGU82SEZ0+z01gkigk+k7MyBdG+ZR2iOfTMWoybfkyNbEjbbHu8KpwdmWSGiLyaByMFlyJox0qEiXSQeLFzkxjHSjYJ/lwNfiTg0bBu2j2OvYlu798uDSqyX3g=
Message-ID: <3ae72650711160715w8479bacs445993b7766e6529@mail.gmail.com>
Date: Fri, 16 Nov 2007 16:15:22 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Subject: Re: [patch 6/6] kernel: Shutdown Actions Interface
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       "Michael Holzheu" <holzheu@de.ibm.com>, "Greg KH" <greg@kroah.com>
In-Reply-To: <20071116143322.198591347@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071116142942.978412023@de.ibm.com>
	 <20071116143322.198591347@de.ibm.com>
X-Google-Sender-Auth: 9348e23d5050c85d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 16, 2007 3:29 PM, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> From: Michael Holzheu <holzheu@de.ibm.com>

> -static struct subsys_attribute dump_type_attr =
> -               __ATTR(dump_type, 0644, dump_type_show, dump_type_store);
> -
> -static decl_subsys(dump, NULL, NULL);

I guess this will conflict with:
http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver/kobject-convert-s390-ipl.c-to-kobj_attr-interface.patch;hb=HEAD

which in in -mm.

Thanks,
Kay

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYDMJk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYDMJk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbYDMJkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:40:22 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:6148 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754543AbYDMJkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:40:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HlS/abEzEX0ugH+boW8Ll4c7rb2QCZ+uMdw4XcbFUWXeyBkhf4EADHz1Y9VggBZn6Nz8iwZRw3Etvup+hYBgQfXRpTyAOhpB8gizhRXgPYurwIGSFWBWQb3nBUBycUNQnfgxLwlt9j3XsWJ6gDT8GKixItYrPbxcL+E6Lix64qo=
Message-ID: <e4957ae10804130240v119fb3d6l861490e25021bcf5@mail.gmail.com>
Date: Sun, 13 Apr 2008 12:40:20 +0300
From: "Uladzislau Rezki" <urezki@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Kernel Oops within Linux Fedore Core 5
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080412125325.36bc029d@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e4957ae10804110813y159019c1p84296058bcc769cf@mail.gmail.com>
	 <20080412125325.36bc029d@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Hi,
>
>  normally (read: 99% of the cases) this happens when your Makefile is buggy.
>  Are you sure your Makefile is correct? Also, are you sure you're compiling
>  against the right kernel headers ?
>
>  Greetings,
>
>    Arjan van de Ven
>
Yes I'm shure that makefile is right, and I'm compiling with right
linux-headers. Bellow you can see Makefile which I use:

obj-m := sb_show.o

KDIR  := /lib/modules/$(shell uname -r)/build
PWD   := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	rm -rf sb_show.ko .sb_show.ko.cmd .sb_show.mod.o.cmd .sb_show.o.cmd
.tmp_versions

--
Uladzislau Rezki

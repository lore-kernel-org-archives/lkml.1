Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbXFMVWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbXFMVWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXFMVWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:22:11 -0400
Received: from server001.webpack.hosteurope.de ([80.237.130.9]:42655 "EHLO
	server001.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbXFMVWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:22:10 -0400
From: Andi Drebes <lists-receive@programmierforen.de>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [KJ] [PATCH] drivers/acpi: sizeof/sizeof array size calculations replaced with ARRAY_SIZE
Date: Wed, 13 Jun 2007 23:21:38 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Len Brown <lenb@kernel.org>, kernel-janitors@lists.osdl.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200705261239.27485.lists-receive@programmierforen.de> <200706122041.06252.lists-receive@programmierforen.de> <200706121253.07395.bjorn.helgaas@hp.com>
In-Reply-To: <200706121253.07395.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706132321.39440.lists-receive@programmierforen.de>
X-bounce-key: webpack.hosteurope.de;lists-receive@programmierforen.de;1181769730;b939f309;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
> You found the right one.  The ACPI CA in Linux is really the same
> as the one from Intel.  Len integrates the Intel one into Linux
> periodically.  He uses scripts or something to format it so it looks
> more like Linux.
Ok. That's what I thought so far.

> I think Len sometimes takes patches against the "Linux-ized" ACPI CA.
> He probably has to apply those by hand to the Intel one, which is
> the real "upstream" in this case.  So it might be a bit easier for
> him if you generated a diff against the Intel version. 
OK. I will do this in the next time.

> In any event, you want to end up with one patch, not two.
Ok. I thought of two patches because I didn't know how strong
the sources from the  ACPI CA are modified.

> You probably would have to add something like:
> 
>   #ifndef ARRAY_SIZE
>   #define ARRAY_SIZE(x) ...
>   #endif
> 
> somewhere in the ACPI CA header files.  That way it will work in
> non-Linux OSes as well.

Thanks so far,
	Andi

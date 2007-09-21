Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbXIUOyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbXIUOyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761007AbXIUOxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:53:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:39112 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761392AbXIUOxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CHoS69VV1UbZxl7AIBqTi27WTUeDVMd1n/9Ls4aB+dMMb8fbp7iOHCePGW7k7y/Y0v50vpRhnLedOTdoTgizfUxjp5BRxZn4J52/h8T3SjjuyzWfHhdbI46QiaLj2dGGI33jojGUWBZnQawqsTWb+fP0pPtGABfLn3lt55n69Ys=
Subject: Re: [Minor patch] Reduce __print_symbol/sprint_symbol stack usage.
From: Gilboa Davara <gilboad@gmail.com>
Reply-To: gilboad@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070921144726.GD15697@goodmis.org>
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>
	 <20070921144726.GD15697@goodmis.org>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 16:53:12 +0200
Message-Id: <1190386392.30016.61.camel@gilboa-home-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 10:47 -0400, Steven Rostedt wrote:
> On Sat, Sep 15, 2007 at 02:35:29PM +0300, Gilboa Davara wrote:
> > -		return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
> > +	if (namebuf)
> > +		kfree(namebuf);
> 
> Note, the if condition is not needed, kfree handles null pointers fine.
> 
> -- Steve

Steve,

This patch has been scrapped and by another,  (hopefully) less
problematic one [1].

Thanks for the comments,
Gilboa

[1] http://lkml.org/lkml/2007/9/21/180





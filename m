Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZKZViy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZKZViy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 16:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZKZVix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 16:38:53 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41986 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZKZViw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 16:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J0qySS87zPNX15OOfnVqts7XvTlbm96PqYmDGbBi2QohBYGY+YP0WiD1gQLT0fbN0+
         QgYKZULn5KPcMdzVwqoFKyC2ViUzPeOXxn7zZOHl+1chH5hMoA4M+1aC5pxrYN5JJTF3
         wtqcqqR/OONhj8vzes3BBr5UO05oUWISU7GKg=
Subject: Re: Plan for adding XD support in mtd layer
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutronix.de
In-Reply-To: <20091126134245.GM10944@logfs.org>
References: <1258894713.4127.4.camel@maxim-laptop>
	 <1259106610.28219.34.camel@maxim-laptop> <20091125104027.GB10944@logfs.org>
	 <1259155258.4875.17.camel@maxim-laptop> <20091125153458.GC10944@logfs.org>
	 <1259165866.10147.35.camel@maxim-laptop> <20091125205942.GF10944@logfs.org>
	 <1259191365.15916.31.camel@maxim-laptop> <20091126082715.GG10944@logfs.org>
	 <1259240574.19687.42.camel@maxim-laptop> <20091126134245.GM10944@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 23:38:52 +0200
Message-ID: <1259271532.24156.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 14:42 +0100, Jörn Engel wrote: 
> On Thu, 26 November 2009 15:02:54 +0200, Maxim Levitsky wrote:
> >
> > This one I have, and there is a brief description of the CIS format,
> > which seems to indicate that its contents are predefined.
> 
> That is my understanding, yes.  Essentially an xD card is just nand
> flash in cheap packaging with the first block filled by CIS/IDI.
> 
> > I am afraid not.
> > 
> > 
> > My plan is to create one 'meta' mtd driver for all XD controllers, and
> > plug in small drivers.
> > 
> > The meta driver and small driver will share the ->priv structure.
> > 
> > I need a way to pass the ID from mtd driver to FTL, and to userspace via
> > mtdchar.
> 
> You can also add a ->priv field to struct xD_data.  Or you can have it
> contain the mtd_info, and use container_of to access the xD information.
> 
> But those are details.  Feel free to write the code either way.  We can
> sort out which method to use later.

Thanks, no more questions, I will publish code as soon as I write one.

Best regards,
Maxim Levitsky


> 
> Jörn
> 



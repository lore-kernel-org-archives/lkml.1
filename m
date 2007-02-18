Return-Path: <linux-kernel-owner+w=401wt.eu-S1751213AbXBRO1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbXBRO1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 09:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXBRO1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 09:27:41 -0500
Received: from mail.edu.haifa.ac.il ([132.74.40.10]:57969 "EHLO
	mail.edu.haifa.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbXBRO1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 09:27:41 -0500
X-Greylist: delayed 2007 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Feb 2007 09:27:41 EST
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
To: "'Ahmed El Zein'" <a.elzein@gawab.net>, "'David Chinner'" <dgc@sgi.com>
Cc: "'Ramy M. Hassan '" <ramy@gawab.com>, <linux-kernel@vger.kernel.org>,
       <xfs@oss.sgi.com>
Subject: RE: xfs internal error on a new filesystem
Date: Sun, 18 Feb 2007 15:56:01 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
Thread-Index: AcdRIiG7SPwLE0pnQZSaMKvb/cKlogCQgjpw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <20070215161932.3230.qmail@info11.gawab.com>
Message-Id: <20070218135844.9300C14A856@mail.edu.haifa.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >> Do u recommend that we switch back to reiserfs ?
> >
> >Not yet.
> >
> >> Could it be a hardware related problems  ?
> >
> >Yes. Do you have ECC memory on your server? Have you run memtest86?
> >Were there any I/O errors in the log prior to the shutdown message?
> Yes, we have ECC memory.
> We will try to run memtest86 as soon as possible.
> There were no I/O errors in the log prior to the shutdown message.
> 
> Btw, this is a vmware image. /vol/6 is an exported physical partition.
> 

I've read that vmware do disk caching by default and we know xfs has problem
with when disaster strikes.

You definitely should disable disk caching on you side. 

> >Cheers,
> >
> >Dave.
> >--
> >Dave Chinner
> >Principal Engineer
> >SGI Australian Software Group
> >
>


Regards,
Leon Kolchinsky
 



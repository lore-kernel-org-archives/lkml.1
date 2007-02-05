Return-Path: <linux-kernel-owner+w=401wt.eu-S965068AbXBEX0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965068AbXBEX0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965069AbXBEX0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:26:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:43004 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068AbXBEX0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=k9DBfC7OiY18UfnQ8dFpbjx8uY776e9MnwX19qgMpJuDwv9fH97rkg44PIodcwUzRUYVVNkF9OYnDdXWUvQzAp4VcGKIE7XP526nBIAVtSx0NVq2eM0o2PIwHq7eIvO5vd4nePZ5gMMPUEt34u6rWloLHxouMuHAcy70tnx39e4=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][0/5] floppy.c: first round of cleanup patches - the simple stuff
Date: Tue, 6 Feb 2007 00:28:31 +0100
User-Agent: KMail/1.9.4
Cc: Andi Kleen <ak@suse.de>, Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702060028.31691.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings people,

Here is, as promised, the first round of cleanup patches for floppy.c
(more will follow later).

I opted to start with the simple stuff first, both to get it out of the way
and also to get something done resonably fast, so don't expect anything 
earth shattering in this first series.

There are 5 patches in this series. They are based on 2.6.20 and are
incremental.

These are the patches (they'll be posted to the same recipients as this initial mail) : 

	[PATCH][1/5] floppy.c: Initial (partial) CodingStyle cleanup
	[PATCH][2/5] floppy.c: Remove pointless register keywords
	[PATCH][3/5] floppy.c: Remove dead/commented out code
	[PATCH][4/5] floppy.c: Add explicit/better printk() levels
	[PATCH][5/5] floppy.c: Fix device_create_file() warning
	
The Cc list is composed of people who expressed interrest in this cleanup +  
people who look like original authors of the code (for whom I could locate 
email addresses).

Comments and (constructive) criticism is welcome.
And if someone feels like merging this upstream you are most welcome :-)


Kind regards,

  Jesper Juhl <jesper.juhl@gmail.com>



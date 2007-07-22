Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbXGVQkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbXGVQkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbXGVQk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:40:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:57463 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbXGVQk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:40:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Bm+FfXrcMBqG4c9sGtUWS/YYtWUTcn7DwVGJvk1PWDLClZuYSNDGUOR1DdNgZI05Ee8SbZe/CuzKReVuD1Ml83PwJLYxQxCxWnrUiAp2+IcFQOXgiBC5a3TavOWM5Ef22FDLWulxw9f6XZ+4rEjytcicriCxkf0IxKacE18EGoY=
Message-ID: <46A387F2.5050704@googlemail.com>
Date: Sun, 22 Jul 2007 18:38:10 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lieven Willems <lw_linux@hotmail.com>, Alan Cox <alan@redhat.com>,
       linux-scsi@vger.kernel.org
Subject: Re: drivers/scsi/sym53c416.c - address of 'sym53c416*' will always
 evaluate as 'true' , warnings
References: <46A36115.3070600@googlemail.com> <20070722162334.GA26883@parisc-linux.org>
In-Reply-To: <20070722162334.GA26883@parisc-linux.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Jul 22, 2007 at 03:52:21PM +0200, Gabriel C wrote:
>> drivers/scsi/sym53c416.c: In function 'sym53c416_detect':
>> drivers/scsi/sym53c416.c:638: warning: the address of 'sym53c416' will always evaluate as 'true'
>> drivers/scsi/sym53c416.c:644: warning: the address of 'sym53c416_1' will always evaluate as 'true'
>> drivers/scsi/sym53c416.c:650: warning: the address of 'sym53c416_2' will always evaluate as 'true'
>> drivers/scsi/sym53c416.c:656: warning: the address of 'sym53c416_3' will always evaluate as 'true'
> 
> These warnings certainly indicate a problem; I've looked through the
> driver and it's a bit of a mess.  Do you have one of these cards?  I can
> write and send you some patches to test on Monday or Tuesday, after I'm
> done with the advansys driver.
> 

Sorry , I don't have these cards :/


Regards,

Gabriel

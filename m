Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbZCMOp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbZCMOp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbZCMOpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:45:16 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:59024 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbZCMOpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=onOiGFXeVNKiWQ+R1OM/iL4A5nUiIlgCCnD6jsWuJVX813cPe9uiwBUy72RwnchVF1
         JETqR1ISS9b8A5D6jGbNnXEPtIuVjE3e0qCiZgI7AOPJkVK0Q0W8QCzKi2ZxuJOvnkhF
         1wDhdx8IHba3La9ln2XCl4W5kiACUI/gmak4o=
Message-ID: <49BA7172.80908@gmail.com>
Date: Fri, 13 Mar 2009 08:45:06 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: n0diamond@yahoo.co.jp
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jim Paris <jim@jtan.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <liml@rtr.ca>
Subject: Re: Off-by-one in both LIBATA and IDE drivers
References: <20090313074120.48682.qmail@web4108.mail.ogk.yahoo.co.jp>
In-Reply-To: <20090313074120.48682.qmail@web4108.mail.ogk.yahoo.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norman Diamond wrote:
> LIBATA with the patch to ata.h now handles all sectors on
> hard drives that it recognizes.
> 
> An example of a hard drive that it recognizes is one that
> is attached to an Intel ICH7M chipset when hda=noprobe
> hdc=noprobe have been specified in the boot command.
> 
> An example of a hard drive that it doesn't recognize is
> one that is attached to an Intel PIIX4 chipset when
> hda=noprobe hdc=noprobe have been specified in the boot
> command.
> 
> In either case, the boot parameters persuade the old IDE
> drivers not to grab the controllers.
> 
> With ICH7M, LIBATA takes over and runs both the hard drive
> and DVD at full speed.
> 
> With PIIX4, LIBATA initializes.  End of story.  Slax can't
> find its own CD.  If I only use hda=noprobe then the old
> IDE controller assigns hdc to the CD and Slax finds it,
> but the hard drive is still undetected.  Behaviour is the
> same under VMware as in a genuine old PC.
> 
> LIBATA's PIIX drivers are built in along with everything
> else.  They just seem not to get executed.
> 
> What am I missing?

I assume that ATA_PIIX is set in the configuration.. The lspci -vn and
dmesg output from when it fails to detect would be useful.

> 
> --------------------------------------
> Power up the Internet with Yahoo! Toolbar.
> http://pr.mail.yahoo.co.jp/toolbar/


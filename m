Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbYHCXoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbYHCXoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 19:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759582AbYHCXnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 19:43:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42300 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758898AbYHCXnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 19:43:55 -0400
Message-ID: <489642AF.3020708@pobox.com>
Date: Sun, 03 Aug 2008 19:43:43 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, petkovbb@gmail.com,
       petkovbb@googlemail.com, alan@redhat.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
References: <20080715053356.GA18628@gollum.tnic>	<20080803073756.GA8762@gollum.tnic>	<20080803125907.67676948@lxorguk.ukuu.org.uk>	<200808031537.41224.bzolnier@gmail.com> <20080803143939.37a74bf5@lxorguk.ukuu.org.uk>
In-Reply-To: <20080803143939.37a74bf5@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The code in question is 65 LOC total (43 LOC without counting comments)
>> so having a shared library just for it sounds like an overkill and we may
> 
> People expect code in C files, so in headers it gets missed as well as
> dumped in a directory with no correlation between file name and subsystem.
> 
>> just copy that one function from pata_legacy to ide_generic instead.
> 
> If you are going to  #include two copies you might as well just copy it.

That's pretty much my feeling...  just copy the code.

If the shared code grows larger, create a kernel module with the stuff 
shared by both libata and drivers/ide.

liblibata?  libata-core-core?  :)

	Jeff



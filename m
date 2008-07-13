Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYGMOqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYGMOqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 10:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYGMOq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 10:46:28 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:38131 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYGMOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 10:46:28 -0400
Message-ID: <487A1534.3000307@diamondcut.com.br>
Date: Sun, 13 Jul 2008 11:46:12 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Greg KH <greg@kroah.com>, linux-acpi@vger.kernel.org, pavel@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: Toshiba - Documentation for Linux Developers
References: <4855971D.90004@diamondcut.com.br> <20080616221443.GA760@kroah.com> <b170af450807130654m2f800b10ybcba4b2c5c7cf329@mail.gmail.com>
In-Reply-To: <b170af450807130654m2f800b10ybcba4b2c5c7cf329@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki wrote:
> 2008/6/17, Greg KH <greg@kroah.com>:
>> Are there any known drivers for Toshiba hardware that you need for Linux
>>  that we should be contacting them about?
>> <http://linux.toshiba-dme.co.jp/linux/eng/develop.htm>
> 
> I have Toshiba A100 with Phoenix BIOS. This means toshiba_acpi doesn't
> work for me and I can change LCD brightness.
> 
> On page http://www.buzzard.me.uk/toshiba/docs.html there is also link
> to pdf with registers info:
> http://www.buzzard.me.uk/toshiba/downloads/hci.pdf
> 
> However I am not programmer and I have no idea if this is some
> interesging info for developrs.

Rafal, try use omnibook driver.
Get it with subversion:
$ svn co
https://omnibook.svn.sourceforge.net/svnroot/omnibook/omnibook/trunk

Use "make install" and "make load".

After this, maybe is possible change brightness writing in
/proc/omnibook/lcd (0 is minimun and 7 is max brightness)

Best regards,
Renato S. Yamane

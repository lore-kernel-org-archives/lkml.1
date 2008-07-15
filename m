Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYGOLNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYGOLNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYGOLNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:13:44 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:40906 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbYGOLNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:13:43 -0400
Message-ID: <487C865C.5060303@diamondcut.com.br>
Date: Tue, 15 Jul 2008 08:13:32 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Greg KH <greg@kroah.com>, linux-acpi@vger.kernel.org, pavel@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: Toshiba - Documentation for Linux Developers
References: <4855971D.90004@diamondcut.com.br> <20080616221443.GA760@kroah.com>	 <b170af450807130654m2f800b10ybcba4b2c5c7cf329@mail.gmail.com>	 <487A1534.3000307@diamondcut.com.br> <b170af450807150017u248d4255i3800c10cb11df319@mail.gmail.com>
In-Reply-To: <b170af450807150017u248d4255i3800c10cb11df319@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki wrote:
> Renato S. Yamane wrote:
>> Rafał Miłecki wrote:
>>> I have Toshiba A100 with Phoenix BIOS. This means toshiba_acpi doesn't
>>> work for me and I can change LCD brightness.
>>
>> Rafal, try use omnibook driver.
>>  Get it with subversion:
>>  $ svn co
>>  https://omnibook.svn.sourceforge.net/svnroot/omnibook/omnibook/trunk
>>
>>  Use "make install" and "make load".
>>
>>  After this, maybe is possible change brightness writing in
>>  /proc/omnibook/lcd (0 is minimun and 7 is max brightness)
> 
> The newest version is packed for openSUSE fortunately. But it doesn't
> for my notebook

Try compile SVN version as commented in my last e-mail

> dmesg is:
> omnibook: Driver version 2.20070211-trunk.
> omnibook: Unknown model.

Try force recognize with ectype parameter.
#modprobe omnibook ectype=x

Where "x" is a number between 1 and 15.

Load with ectype=1, test, unload, try load again with ectype=2, test,
unload...

Best regards,
Renato

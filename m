Return-Path: <linux-kernel-owner+w=401wt.eu-S933592AbXHFSod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbXHFSod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765982AbXHFSoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:44:14 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:19284 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbXHFSoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Osq8tU/3G8v/a8UDqDNBNNZllrBOkd9s3H6O8hyJir8O4vKlj65AvVAe7IIdKUYY0lfaaJkFew8CkWA18rUnk7Wf7q84g63ZXBTyP/A+kechiXQRdHdQoKLU51OKeIvXG4dT4HWFBdBME4ElU2LgipXYZLXvpKhjMD6ceOAZjGI=
Message-ID: <46B76BBC.9010107@gmail.com>
Date: Tue, 07 Aug 2007 03:43:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Michael Sedkowski <sedmich@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>	 <1186411815.4355.7.camel@nx6310>	 <20070806150159.GC31615@khazad-dum.debian.net>	 <200708061732.03425.rjw@sisk.pl>  <46B75459.9020204@gmail.com> <1186424492.4355.1.camel@nx6310>
In-Reply-To: <1186424492.4355.1.camel@nx6310>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Sedkowski wrote:
>> Hmmm... If the problem only shows up on nx6325, it might be that ACPI is
>> pulling unnecessary stunt.  Please apply the attached patch and report
>> when the disk spins down and up.
> 
> Disk spins down on "Pre-shutdown prepare" and then goes up and down on
> "Power down".

Oh... crap, so acpi wants to sync cache on shutdown.  I wonder whether
it spins down the disk correctly.  Does emergency unload count increase
after each power down?  Also, please post the result of 'dmidecode'.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S965614AbXAXCII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965614AbXAXCII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965612AbXAXCII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:08:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:17298 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965614AbXAXCIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:08:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uvTuV1AxiYq4bL4LbiLrvtz/11HkOTn+SAZz3KSvucnNZh2LE3thBPl6euT2S0hUUoZ87+pgHuGjFfZVTQuSxLwtGGzXhNOjhjaEovxjpYmur9vVRchnvRjFg1Yn19J5EMhmCI5RgAqnIPzd9HCRNhGtTo4BBGAuFa7HcZj8kxQ=
Message-ID: <45B6BF5D.1070300@gmail.com>
Date: Wed, 24 Jan 2007 11:07:25 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Soeren Sonnenburg <kernel@nn7.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SATA hotplug from the user side ?
References: <1168588629.5403.7.camel@localhost> <45A7BFB0.9090308@garzik.org> <1168639639.3707.6.camel@localhost> <45A83C22.6050409@gmail.com> <1168672966.3707.24.camel@localhost> <45AAE52B.2070705@gmail.com> <1169456682.2901.18.camel@localhost> <20070122210312.GD4516@khazad-dum.debian.net> <45B5A9C7.5050700@gmail.com> <20070123131040.GB13467@khazad-dum.debian.net>
In-Reply-To: <20070123131040.GB13467@khazad-dum.debian.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Tue, 23 Jan 2007, Tejun Heo wrote:
>> Henrique de Moraes Holschuh wrote:
>>> Does SATA electrical conector keying let the disk firmware unload
>>> heads before the user manages to pull it out enough to sever power?
>> I don't think so.
> 
> Heh, thought as much. (Good) SCSI hotswap bays notice you pulled the disk
> release lever and issue an START_STOP_UNIT by themselves to the disk well
> before you have time to start pulling the disk out.  I wonder if the SATA
> ones do (I kind of doubt that, SATA seems to attract the el-cheapo, el-crapo
> crowd of manufacturers).

ahci controller spec has places for such thing but I've never seen it
actually implemented.  I'm thinking about a CLI tool to list & control
libata devices including hotplugging, NCQ and other stuff.  Eventually,
it would be really nice to give the user/admin easy gui/web/whatever
tool to watch and control ATA devices.

>>> If it does not, the drive will do an emergency head unload, which is
>>> not good and will likely reduce the drive's lifetime.
>> Probably.
> 
> So, that means it should be explained in the docs that you are to stop the
> disk first, if you can.

Yeap, agreed.

> Even if hald does this automatically, it would still be a very good idea to
> document the proper sequence, IMO...

Agreed.

-- 
tejun

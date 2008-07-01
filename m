Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbYGAVzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbYGAVzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYGAVzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:55:07 -0400
Received: from nebensachen.de ([195.34.83.29]:56286 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbYGAVzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:55:06 -0400
X-Hashcash: 1:20:080701:xfs-masters@oss.sgi.com::MA7OofUGazuwEi3Z:000000000000000000000000000000000000001iZq
X-Hashcash: 1:20:080701:rjw@sisk.pl::ErSNaEsmqQp8BRC3:0000000HI2
X-Hashcash: 1:20:080701:jeremy@goop.org::96JREbB8quZ08Ja2:0042Aj
X-Hashcash: 1:20:080701:hmh@hmh.eng.br::v4G+VmrPqbhT0CO5:00057GC
X-Hashcash: 1:20:080701:mrmacman_g4@mac.com::bXEoJWiiVSZdU9sK:00000000000000000000000000000000000000000048Nv
X-Hashcash: 1:20:080701:mjg59@srcf.ucam.org::48i4tLTeyqHzT1mP:00000000000000000000000000000000000000000050Ju
X-Hashcash: 1:20:080701:linux-kernel@vger.kernel.org::BuhXXzp7td5Gp4h/:00000000000000000000000000000000010eO
X-Hashcash: 1:20:080701:jens.axboe@oracle.com::JL1BPZUQnxb1mZOw:0000000000000000000000000000000000000000075S
From: Elias Oltmanns <eo@nebensachen.de>
To: xfs-masters@oss.sgi.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
References: <4744FD87.7010301@goop.org> <200807010038.43362.rjw@sisk.pl>
	<20080701063835.GQ29319@disturbed> <200807011635.44696.rjw@sisk.pl>
	<87tzf9hcg6.fsf@denkblock.local> <20080701211550.GU29319@disturbed>
Date: Tue, 01 Jul 2008 23:46:34 +0200
Message-ID: <87abh1nupx.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Jul 01, 2008 at 05:05:29PM +0200, Elias Oltmanns wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
>> > Do all of the filesystems implement the freezing?
>> 
>> There is some work in progress [1].
> [....]
>> [1] http://permalink.gmane.org/gmane.linux.file-systems/24716
>
> No, that's the userspace ioctl interface to enable freezing from
> something other than dm-snapshot. The filesystems that is aimed at
> already support freezing via freeze_bdev().

Yes, Christoph mentioned that too and I should have realised it had I
looked at those patches properly.

Regards,

Elias

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbZBSP0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbZBSP0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZBSP0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:26:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46599 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbZBSP0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:26:10 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: CFQ is worse than other IO schedulers in some cases
References: <499BA413.2010705@cn.fujitsu.com>
	<20090218113704.GW30821@kernel.dk> <499D2654.4060903@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 19 Feb 2009 10:26:02 -0500
In-Reply-To: <499D2654.4060903@cn.fujitsu.com> (Shan Wei's message of "Thu, 19
	Feb 2009 17:28:52 +0800")
Message-ID: <x491vtu8n3p.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shan Wei <shanwei@cn.fujitsu.com> writes:

> To Jeff:
>
>  The patch can be used on Fedora10. But, on fedora8, the CLONE_IO is not 
> included in the sched.h. So compile fail.
>
> #make
> /usr/local/etc/dumpdates\" -D_DUMP_VERSION=\"0.4b41\"     tape.c -o tape.o
> tape.c: In function ‘fork_clone_io’:
> tape.c:797: error: ‘CLONE_IO’ undeclared (first use in this function)
> tape.c:797: error: (Each undeclared identifier is reported only once
> tape.c:797: error: for each function it appears in.)
> make[1]: *** [tape.o] Error 1

Great, thanks for testing!  I'll fix that up.

Cheers,
Jeff

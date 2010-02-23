Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0BWRiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:38:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab0BWRit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:38:49 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: GeunSik Lim <leemgs1@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: question on readahead and sync mounting
References: <201002230032.18705.oliver@neukum.org>
	<49b7c2351002221548ma5b8e81m80ac4b60a6eb9d9d@mail.gmail.com>
	<201002230059.09390.oliver@neukum.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 23 Feb 2010 12:38:44 -0500
In-Reply-To: <201002230059.09390.oliver@neukum.org> (Oliver Neukum's message
	of "Tue, 23 Feb 2010 00:59:09 +0100")
Message-ID: <x497hq34ztn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum <oliver@neukum.org> writes:

> Am Dienstag, 23. Februar 2010 00:48:39 schrieben Sie:
>> Please, Refer to below articles to understand readahead essentially.
>> 
>> http://lwn.net/Articles/235164/ (On-demand readahead by corbet)
>> http://kernelnewbies.org/Linux_2_6_23#head-102af265937262a7a21766ae58fddc1a29a5d8d7(
>> On-demand read-ahead on Linux 2.6.23)
>
> OK, I am looking for a way to make sure read requests on a SCSI drive
> actually hit the bus after a certain event. Is there a way to do this without
> tossing away the whole cache?

I'm not sure I understand what you're asking, but it sounds like you
want to do an O_DIRECT read.  Open the file with O_DIRECT, then pass
a properly-aligned buffer to the read(2) call.

Cheers,
Jeff

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0CJNV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:21:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab0CJNVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:21:54 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: M vd S <mvds.00@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK is NOOP on block devices
References: <4B904D98.50602@gmail.com> <4B9060DE.4080104@gmail.com>
	<4B96ECDD.1070006@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 10 Mar 2010 08:21:51 -0500
In-Reply-To: <4B96ECDD.1070006@gmail.com> (M. vd S.'s message of "Wed, 10 Mar
	2010 01:50:37 +0100")
Message-ID: <x494oko5n2o.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

M vd S <mvds.00@gmail.com> writes:
> I also briefly tried aio_* and the libaio interface. The former is not
> really asynchronous - all requests are put in one separate thread
> where they will be executed in order, i.e. blocking, so you don't get
> any advantage from NCQ or data that was cached by the disk or the
> kernel. The latter apparently ends in an io_submit() which will block
> until all queued reads are finished, but I might have missed something
> there.

What you missed is that the native aio system calls require O_DIRECT.

Cheers,
Jeff

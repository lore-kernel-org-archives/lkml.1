Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZKJP4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZKJP4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756735AbZKJPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:55:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbZKJPz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:55:59 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, aaronc@gelato.unsw.edu.au
Subject: Re: [RFC, PATCH] cfq-iosched: remove redundant queuing detection code
References: <200911101454.57522.czoccolo@gmail.com>
	<20091110151431.GI8742@kernel.dk>
	<x49ocna5rv1.fsf@segfault.boston.devel.redhat.com>
	<20091110152745.GK8742@kernel.dk>
	<x49k4xy5qw6.fsf@segfault.boston.devel.redhat.com>
	<20091110154809.GL8742@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Nov 2009 10:55:47 -0500
In-Reply-To: <20091110154809.GL8742@kernel.dk> (Jens Axboe's message of "Tue,
	10 Nov 2009 16:48:09 +0100")
Message-ID: <x49fx8m5q7w.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

>> Why don't we simply use the value configured via the queue_depth sysfs
>> file?
>
> First of all, that only covers SCSI. We could do that by having the tag
> on/off functions set the same flag. But even for such devices, actual
> tag depth is dependent upon what other devices are on the controller
> (since it's often a shared map) and may not even be statically
> detectable in the sense that actual depth is only really seen when the
> device returns busy on a queue attempt.
>
> In most cases it would work fine, but the dynamic detection is more
> reliable. The sysfs setting in reality is max setting.

OK, thanks for the patient explanation, Jens!

Cheers,
Jeff

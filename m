Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZLITDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZLITDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbZLITDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:03:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686AbZLITDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:03:07 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       guijianfeng@cn.fujitsu.com
Subject: Re: [PATCH 1/2] cfq-iosched: Get rid of cfqq wait_busy_done flag
References: <1260312778-4725-1-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 09 Dec 2009 14:03:06 -0500
In-Reply-To: <1260312778-4725-1-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Tue, 8 Dec 2009 17:52:57 -0500")
Message-ID: <x49fx7knf6d.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> o Get rid of wait_busy_done flag. This flag only tells we were doing wait
>   busy on a queue and that queue got request so expire it. That information
>   can easily be obtained by (cfq_cfqq_wait_busy() && queue_is_not_empty). So
>   remove this flag and keep code simple.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

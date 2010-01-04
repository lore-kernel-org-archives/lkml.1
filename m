Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462Ab0ADPEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0ADPEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336Ab0ADPEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:04:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab0ADPEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:04:24 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe\@oracle.com" <jens.axboe@oracle.com>,
       "Zhang\, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [PATCH]cfq-iosched: split seeky coop queues after one slice
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	<4e5e476b0912250216n2b4aceacyf22a0e73425efd3a@mail.gmail.com>
	<20091228031951.GA15242@sli10-desk.sh.intel.com>
	<4e5e476b0912280040ue2eb50ftd3945f28270899c0@mail.gmail.com>
	<20091228085221.GA3769@sli10-desk.sh.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 04 Jan 2010 10:04:17 -0500
In-Reply-To: <20091228085221.GA3769@sli10-desk.sh.intel.com> (Shaohua Li's
	message of "Mon, 28 Dec 2009 16:52:21 +0800")
Message-ID: <x49iqbhc3ny.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> Currently we split seeky coop queues after 1s, which is too big. Below patch
> marks seeky coop queue split_coop flag after one slice. After that, if new
> requests come in, the queues will be splitted. Patch is suggested by Corrado.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Reviewed-by: Corrado Zoccolo <czoccolo@gmail.com>

This makes a lot of sense.  Thanks for looking into it.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

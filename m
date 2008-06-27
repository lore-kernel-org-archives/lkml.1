Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbYF0NM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbYF0NM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYF0NMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:12:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYF0NMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:12:48 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: avoid using queue_delayed_work in aio_kick_handler to schedule itself
References: <200806260927.27995.knikanth@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 27 Jun 2008 09:11:37 -0400
In-Reply-To: <200806260927.27995.knikanth@suse.de> (Nikanth Karthikesan's
	message of "Thu, 26 Jun 2008 09:27:27 +0530")
Message-ID: <x49prq3t43a.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan <knikanth@suse.de> writes:

> Avoid using queue_delayed_work in aio_kick_handler() to run itself 
> immediately. Instead use aio_run_all_iocbs()

Can you give some rationale for this change?  Also, how did you test it?

Cheers,

Jeff

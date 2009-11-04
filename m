Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZKDSpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZKDSpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZKDSpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:45:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbZKDSpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:45:02 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 10/20] blkio: Implement cfq group deletion and reference counting support
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	<1257291837-6246-11-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 13:44:42 -0500
In-Reply-To: <1257291837-6246-11-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Tue, 3 Nov 2009 18:43:47 -0500")
Message-ID: <x49ljimt9id.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:


> +extern void cfq_delink_blkio_group(void *, struct blkio_group *);

s/delink/unlink/g

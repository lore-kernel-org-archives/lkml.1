Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYIIAj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYIIAj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYIIAjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:39:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462AbYIIAjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:39:18 -0400
Date: Mon, 8 Sep 2008 17:39:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
       danielm77@spray.se
Subject: Re: [PATCH bz #11425] tpm: release memory on init failure
Message-Id: <20080908173900.f90b7d15.akpm@linux-foundation.org>
In-Reply-To: <20080908104530.f9aed821.randy.dunlap@oracle.com>
References: <20080908104530.f9aed821.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 10:45:30 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> For kernel bugzilla #11425:
> http://bugzilla.kernel.org/show_bug.cgi?id=11425
> 
> Release memory on init failure.

Seems I already fixed it: 
http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch

(identical to yours, with a different label name).

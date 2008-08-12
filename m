Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYHLW6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYHLW6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYHLW6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:58:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbYHLW6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:58:39 -0400
Date: Tue, 12 Aug 2008 15:58:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ia64 allmodconfig on current mainline
Message-Id: <20080812155806.4e8554a9.akpm@linux-foundation.org>
In-Reply-To: <200808130022.50501.rjw@sisk.pl>
References: <20080812150608.231a948a.akpm@linux-foundation.org>
	<200808130022.50501.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 00:22:50 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, 13 of August 2008, Andrew Morton wrote:
> > /opt/crosstool/gcc-3.4.5-glibc-2.3.6/ia64-unknown-linux-gnu/bin/ia64-unknown-linux-gnu-ld: section .data [0000000004ea0000 -> 0000000004f656e7] overlaps section .data.percpu [0000000004e90000 -> 0000000004ea0d17]
> > make: *** [.tmp_vmlinux1] Error 1
> 
> I gather this is a regression from .26?

yes, more recent than that, actually.  2.6.27-rc1-mm1 was OK.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbYKAGzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbYKAGzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 02:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYKAGz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 02:55:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbYKAGz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 02:55:27 -0400
Date: Fri, 31 Oct 2008 23:54:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: ext3 __log_wait_for_space: no transactions
Message-Id: <20081031235459.055c35d7.akpm@linux-foundation.org>
In-Reply-To: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 11:49:34 +0200 (EET) Meelis Roos <mroos@linux.ee> wrote:

> I get this problem nightly on 2.6.28-rc2-* kernels on a generic
> Celeron 900/Intel 815/PATA/ext3 system.
> 
> __log_wait_for_space: no transactions
> Aborting journal on device sda3.
> ext3_abort called.
> EXT3-fs error (device sda3): ext3_journal_start_sb: Detected aborted journal
> Remounting filesystem read-only

ug.  Was 2.6.27 OK?

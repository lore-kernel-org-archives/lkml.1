Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbZJFTxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbZJFTxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbZJFTxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:53:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbZJFTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:53:16 -0400
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andy Whitcroft <apw@canonical.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1254406711.18167.88.camel@desktop>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	 <4AB86ED1.1040200@cn.fujitsu.com>  <20090930152708.GD2957@shadowen.org>
	 <1254406711.18167.88.camel@desktop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 06 Oct 2009 15:51:17 -0400
Message-Id: <1254858677.1696.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 07:18 -0700, Daniel Walker wrote:
> On Wed, 2009-09-30 at 16:27 +0100, Andy Whitcroft wrote:

>         TP_STRUCT__entry(
>                 __field(        dev_t,  dev                     )
>                 __field(        ino_t,  ino                     )
>                 __field(        umode_t, mode                   )
>                 __field(        uid_t,  uid                     )
>                 __field(        gid_t,  gid                     )
>                 __field(        blkcnt_t, blocks                )
>         ),

Yes, the whitespaces for __field and __array as well as __field_ext and
__dynamic_array, and __sting, in this file can be ignored. As for the
rest of the file, perhaps it would be good to still check them.

-- Steve



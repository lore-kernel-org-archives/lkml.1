Return-Path: <linux-kernel-owner+w=401wt.eu-S934854AbXLQVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854AbXLQVqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759174AbXLQVp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:45:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36148 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757052AbXLQVp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:45:58 -0500
Date: Mon, 17 Dec 2007 13:43:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "John Stoffel" <john@stoffel.org>
Cc: john@stoffel.org, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: 2.6.24-rc5: tape drive not responding
Message-Id: <20071217134344.3f024461.akpm@linux-foundation.org>
In-Reply-To: <18278.58314.892734.490418@stoffel.org>
References: <18277.52079.718004.969358@stoffel.org>
	<20071217112551H.fujita.tomonori@lab.ntt.co.jp>
	<20071217031510.c3d500fd.akpm@linux-foundation.org>
	<18278.55130.471797.398922@stoffel.org>
	<18278.58314.892734.490418@stoffel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 16:02:02 -0500
"John Stoffel" <john@stoffel.org> wrote:

> 
> Just to confirm, the propsed patch to st.c fixes the issue with
> 2.6.24-rc5 as well at 2.6.24-rc5-mm1 with access to my DLT tape
> drives.

err, what patch to st.c?

So it seems that 2.6.24 (and presumably 2.6.23?) need

1: Alan's "initio: fix conflict when loading driver" (currently stocuk
   in git-scsi-misc)

2: Boaz's "initio: initio_build_scb() fix" (my name for it)

3: The mystery st.c fix.

yes?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764769AbXFRVfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764769AbXFRVfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760090AbXFRVe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:34:57 -0400
Received: from mail.samba.org ([66.70.73.150]:45599 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761665AbXFRVe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:34:56 -0400
Date: Mon, 18 Jun 2007 14:34:38 -0700
From: Jeremy Allison <jra@samba.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: alan <alan@clueserver.org>, Bodo Eggert <7eggert@gmx.de>,
       Theodore Tso <tytso@mit.edu>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618213438.GK1152@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <8wst3-3kh-31@gated-at.bofh.it> <8wsCC-3wf-21@gated-at.bofh.it> <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4676F9A2.6010007@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:31:14PM -0700, H. Peter Anvin wrote:

> And that makes them different from extended attributes, how?

Streams on systems that support them allow lseek and are
accessed by fd's. EA's are always a blob of data, read/written
in their entirity.

Jeremy.

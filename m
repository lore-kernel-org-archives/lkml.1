Return-Path: <linux-kernel-owner+w=401wt.eu-S1761862AbXHUQz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862AbXHUQz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 12:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758330AbXHUQzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 12:55:49 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43054 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956AbXHUQzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 12:55:48 -0400
Date: Tue, 21 Aug 2007 12:55:44 -0400
To: John Stoffel <john@stoffel.org>
Cc: Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
Message-ID: <20070821165544.GA27995@fieldses.org>
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18123.5699.405125.137517@stoffel.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 12:43:47PM -0400, John Stoffel wrote:
> Robin> I've read every man page I could find, and the only nfs option
> Robin> that semes even vaguely helpful is "soft", but everything that
> Robin> mentions "soft" also says to never use it.
> 
> I think the man pages are out of date, or ignoring reality.

No.  The price of using "soft" is the chance of data corruption, since
an application may for example be left thinking that a write has
succeeded when it hasn't.  See

	http://nfs.sourceforge.net/#faq_e4

--b.

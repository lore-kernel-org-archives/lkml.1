Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbXHETrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbXHETrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 15:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbXHETrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 15:47:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35080 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbXHETro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 15:47:44 -0400
Subject: Re: lvcreate on 2.6.22.1: kernel tried to execute NX-protected page
From: Arjan van de Ven <arjan@infradead.org>
To: Juergen Kreileder <jk@blackdown.de>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
In-Reply-To: <87y7gperd1.fsf@blackdown.de>
References: <87y7gperd1.fsf@blackdown.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 05 Aug 2007 12:46:03 -0700
Message-Id: <1186343163.25667.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-05 at 21:03 +0200, Juergen Kreileder wrote:
> I've upgraded devmapper to 1.02.20 and lvm2 to 2.02.26.  Didn't help much,
> I just got a the same BUG again:
> 
> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> BUG: unable to handle kernel paging request at virtual address f492c1f8


I suspect this is a module that got unloaded but still had some function
pointer registered somewhere.....

do you know if/which module that could be?
(one trick is to compile the kernel such that you don't allow modules to
be unloaded at all; if that makes it work it's clearly the type of bug I
described above)



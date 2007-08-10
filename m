Return-Path: <linux-kernel-owner+w=401wt.eu-S939193AbXHJOum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939193AbXHJOum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759899AbXHJOue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:50:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57562 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593AbXHJOud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:50:33 -0400
Subject: Re: Noatime vs relatime
From: Arjan van de Ven <arjan@infradead.org>
To: Vlad <vladc6@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <233939.75965.qm@web54403.mail.yahoo.com>
References: <233939.75965.qm@web54403.mail.yahoo.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 10 Aug 2007 07:47:37 -0700
Message-Id: <1186757257.2670.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-08-10 at 07:26 -0700, Vlad wrote:
> Linus Torvalds wrote:
> Relatime seems to be wasteful of both IO resources _and_ CPU cycles.
> Instead of performing a single IO operation (as atime does), relatime
> performs at least three IO operations and three CPU-dependent
> operations:


> 
> 1) a read IO operation to find out the old atime
> 2) a read IO operation to find out the old ctime
> 3) a read IO operation to find out the old mtime

you've mistaken the concept of inode-in-memory... there is no IO
involved in any of these.



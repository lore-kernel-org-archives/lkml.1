Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbXBLIBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbXBLIBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 03:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933088AbXBLIBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 03:01:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39873 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbXBLIBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 03:01:04 -0500
Subject: Re: [QUESTION] file access time in millisecond?
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com>
References: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 12 Feb 2007 09:01:00 +0100
Message-Id: <1171267260.3081.32.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 15:27 +0800, Jeff Chua wrote:
> Is it possible to get file access time in millisecond resolution?
> 
> stat() returns time in seconds, but gettimeofday() can returns microseconds.

see the "utimes()" function



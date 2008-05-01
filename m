Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbYEBKQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbYEBKQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbYEBKQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:16:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57413 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759094AbYEBKQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:16:15 -0400
Date: Thu, 1 May 2008 05:15:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or
 directory".
Message-ID: <20080501051548.08bbbec1@infradead.org>
In-Reply-To: <481ACEC4.2040205@krogh.cc>
References: <4819E316.7000607@krogh.cc>
	<20080501223938.921f7cd2.akpm@linux-foundation.org>
	<481ACEC4.2040205@krogh.cc>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008 10:20:20 +0200
Jesper Krogh <jesper@krogh.cc> wrote:
> Hardware is an Sun Fire X4600 (8xdual-core AMD64 processors). The
> problem seem to be tied to this filesystem. (I cannot havent been able
> to reproduce it on the /-mounted disk of the same system. So if a cpu
> problem.. then it shouldn't be tied to a specific filesystem?
> 
> This is the only activity on the system .. so a load of 1 / 16cpus.

have you run fsck on the filesystem?
(and it might be interesting to use dump the metadata to a file first
to save the broken state for later analysis)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbXI0N5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbXI0N5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 09:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbXI0N5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 09:57:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60296 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbXI0N5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:57:03 -0400
Date: Thu, 27 Sep 2007 06:56:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH -mm] task_struct: move ->fpu_counter and ->oomkilladj
Message-ID: <20070927065611.45c479fb@laptopd505.fenrus.org>
In-Reply-To: <20070927095557.GA6758@localhost.sw.ru>
References: <20070927095557.GA6758@localhost.sw.ru>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 13:55:57 +0400
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> There is nice 2 byte hole after struct task_struct::ioprio field
> into which we can put two 1-byte fields: ->fpu_counter and
> ->oomkilladj.
> 
> [cc'ing Arjan just in case ->fpu_counter placement wasn't completely
> random :^)]


fpu_counter was more or less random, but it does get written to
frequently (making the cacheline dirty)

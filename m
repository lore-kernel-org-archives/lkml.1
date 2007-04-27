Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbXD0RQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbXD0RQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbXD0RQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:16:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:56516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756729AbXD0RQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:16:14 -0400
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 18/38] Improved oops output.
References: <20070427140503.087958775@de.ibm.com>
	<20070427140516.013904506@de.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Apr 2007 20:14:01 +0200
In-Reply-To: <20070427140516.013904506@de.ibm.com>
Message-ID: <p733b2l3ct2.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky <schwidefsky@de.ibm.com> writes:

> Second a disassembler is added that decodes the instructions surrounding
> the faulting PSW. 

Is that really needed? I use a simple wrapper around as/objdump for this
and it works great.

(ftp://ftp.firstfloor.org/pub/ak/shell/decodecode) 

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbXIRRCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbXIRRCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759436AbXIRRC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:02:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbXIRRCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:02:25 -0400
Date: Tue, 18 Sep 2007 10:01:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-Id: <20070918100115.b9da8ad5.akpm@linux-foundation.org>
In-Reply-To: <46EFE6D7.3070105@bull.net>
References: <20070918091728.GA6766@localhost.sw.ru>
	<20070918032727.c07aa521.akpm@linux-foundation.org>
	<46EFE6D7.3070105@bull.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 16:55:19 +0200 Nadia Derbey <Nadia.Derbey@bull.net> wrote:

> This patch fixes the missing rcu_read_(un)lock in the ipc code

Thanks.  Could you please check the code comments in ipc/util.c for
accuracy and completeness sometime?

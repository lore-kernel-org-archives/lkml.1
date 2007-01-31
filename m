Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbXAaKus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbXAaKus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbXAaKur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:50:47 -0500
Received: from smtp25.orange.fr ([193.252.22.23]:51484 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005AbXAaKur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:50:47 -0500
X-ME-UUID: 20070131105045248.3C7DC1C000A0@mwinf2511.orange.fr
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
From: Xavier Bestel <xavier.bestel@free.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0701301853190.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	 <1170209044.26655.364.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0701301853190.3611@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 11:50:36 +0100
Message-Id: <1170240636.24358.41.camel@frg-rhel40-em64t-03>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 19:02 -0800, Linus Torvalds wrote:
> Btw, this is also something where we should just disallow certain system 
> calls from being done through the asynchronous method. 

Does that mean that doing an AIO-disabled syscall will wait for all in-
flight AIO syscalls to finish ?

	Xav



Return-Path: <linux-kernel-owner+w=401wt.eu-S1030657AbXCLQuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030657AbXCLQuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030659AbXCLQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:50:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48830 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030657AbXCLQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:50:13 -0400
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
From: Dave Hansen <hansendc@us.ibm.com>
To: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45F57E7D.6080604@sw.ru>
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>
	 <m14porwq1c.fsf@ebiederm.dsl.xmission.com>  <45F57E7D.6080604@sw.ru>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 09:50:08 -0700
Message-Id: <1173718208.11945.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 19:23 +0300, Kirill Korotaev wrote:
> 
> For these you essentially need per-container page->_mapcount counter,
> otherwise you can't detect whether rss group still has the page in question being mapped
> in its processes' address spaces or not. 

What do you mean by this?  You can always tell whether a process has a
particular page mapped.  Could you explain the issue a bit more.  I'm
not sure I get it.

-- Dave


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYD2FHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYD2FHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYD2FHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:07:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:34800 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYD2FHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:07:24 -0400
Subject: Re: PTRACE_{READ,WRITE}{TEXT,DATA}
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Rik van Riel <riel@redhat.com>
Cc: David Miller <davem@davemloft.net>, roland@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080429004405.2c375723@bree.surriel.com>
References: <1209441248.18023.124.camel@pasglop>
	 <20080428.213416.193699665.davem@davemloft.net>
	 <20080429004405.2c375723@bree.surriel.com>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 15:06:56 +1000
Message-Id: <1209445616.18023.133.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Strange, changing access_process_vm on Fedora 9 made gdb able to
> see video memory that the X server had mmapped.
> 
> Are you sure gdb behaves as you suggest?  
> 
> On x86 my patch seems to work as I expected...

Because /proc/<pid>/mem also uses access_process_vm(). See
fs/proc/base.c

Cheers,
Ben.



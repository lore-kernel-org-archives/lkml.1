Return-Path: <linux-kernel-owner+w=401wt.eu-S1765103AbYHEU44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765103AbYHEU44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763342AbYHEUzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:55:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758333AbYHEUzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:55:01 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
From: Eric Paris <eparis@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
In-Reply-To: <20080805133832.220d71c7@infradead.org>
References: <20080805112747.2c3c4650@infradead.org>
	 <2629CC4E1D22A64593B02C43E85553030480743E@USILMS12.ca.com>
	 <20080805183845.GA11375@kroah.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4AD9@USILMS12.ca.com>
	 <20080805133832.220d71c7@infradead.org>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 16:54:53 -0400
Message-Id: <1217969693.27684.181.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 13:38 -0700, Arjan van de Ven wrote:
> and again please explain how you
> deal with write-to-mmap-after-close)

http://marc.info/?l=linux-security-module&m=121796172212429&w=2

Write after close will invalidate the close time caching decision, but
will still get caught on the next open....

-Eric


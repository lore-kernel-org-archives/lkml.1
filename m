Return-Path: <linux-kernel-owner+w=401wt.eu-S933893AbYBUQrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893AbYBUQrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757696AbYBUQrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:47:42 -0500
Received: from verein.lst.de ([213.95.11.210]:44201 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYBUQrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:47:41 -0500
Date: Thu, 21 Feb 2008 17:46:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: 2.6.25-rc2-mm1 - several bugs and a crash
Message-ID: <20080221164632.GA31784@lst.de>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47BC982C.7050402@imap.cc> <20080221043828.bcd5cbce.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221043828.bcd5cbce.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 04:38:28AM -0800, Andrew Morton wrote:
> (net-related cc's removed)
> 
> This look like a startup ordering bug in mnt_want_write().

Do you have CONFIG_ACPI_CUSTOM_DSDT_INITRD set?

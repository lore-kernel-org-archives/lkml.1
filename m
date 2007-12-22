Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbXLVPys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbXLVPys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 10:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXLVPyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 10:54:39 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37365 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbXLVPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 10:54:38 -0500
Date: Sat, 22 Dec 2007 08:54:37 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       torvalds@linux-foundation.org
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver opt-in issue
Message-ID: <20071222155436.GS29690@parisc-linux.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222064719.73fdd9a4@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 06:47:19AM -0800, Arjan van de Ven wrote:
> Do you hate the name or the concept? I'm certainly open for a better name.... 

I hate the concept.  We should just fall back to type1 accesses on
mmconfig machines for all accesses below 64 bytes, as Ivan suggested.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

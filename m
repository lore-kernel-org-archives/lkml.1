Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbYA2Dh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbYA2Dh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 22:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYA2DhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 22:37:15 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:34922 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYA2DhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 22:37:13 -0500
Date: Mon, 28 Jan 2008 20:37:12 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: DMA mapping on SCSI device?
Message-ID: <20080129033712.GG20198@parisc-linux.org>
References: <479E6E8C.2090501@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479E6E8C.2090501@shaw.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 06:08:44PM -0600, Robert Hancock wrote:
> The 
> thought of using the SCSI struct device for DMA mapping was brought up 
> at one point.. any thoughts on that?

I believe this will work on some architectures and not others.
Anything that uses include/asm-generic/dma-mapping.h will break, for
example.  It would be nice for those architectures to get fixed ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbYHRTGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbYHRTGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762637AbYHRTEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:04:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35332 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761965AbYHRTEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:04:32 -0400
Date: Mon, 18 Aug 2008 13:04:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Matt_Domsch@dell.com,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long Physical Sectors
Message-ID: <20080818190431.GA21854@parisc-linux.org>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx> <1217957207-23116-3-git-send-email-matthew@wil.cx> <48A8B211.8030103@pobox.com> <20080818181523.GG677@parisc-linux.org> <20080818190629.22fd618c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818190629.22fd618c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 07:06:29PM +0100, Alan Cox wrote:
> > +	static const char command_sect_size[256] = {
> > +		[ ATA_CMD_CFA_TRANSLATE_SECTOR ] = DEVICE,
> 
> Should be a bit array so we can do a single fast test_bit()

... err ... any idea what the syntax might be for initialising a bit
array at compile time?  Do I have to use an initialiser function at
runtime?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

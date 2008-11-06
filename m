Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbYKFQ73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbYKFQ73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYKFQ7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:59:06 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50358 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690AbYKFQ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:59:04 -0500
Date: Thu, 6 Nov 2008 11:59:00 -0500
From: Theodore Tso <tytso@mit.edu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH]: ext4: fix big endian  (was: not enough memory for
	522250 flex groups)
Message-ID: <20081106165900.GC18939@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811061651.49602.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 04:51:49PM +0100, Christian Borntraeger wrote:
> Ok, I think I found it:
> 
> On big endianess plattforms newly created ext4 file systems cannot be mounted
> and show messages like:
> [6923911.715968] EXT4-fs: not enough memory for 522250 flex groups
> [6923911.715973] EXT4-fs: unable to initialize flex_bg meta info!
> 
> We have to access s_reserved_gdb_blocks with le16_to_cpu.

Aneesh has already submitted a patch to fix this; I'll be pushing it
to Linus shortly.

						- Ted

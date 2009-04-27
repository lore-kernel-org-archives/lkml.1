Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbZD0WtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbZD0WtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZD0WtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:49:13 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42429 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbZD0WtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:49:12 -0400
Date: Tue, 28 Apr 2009 07:43:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roland McGrath <roland@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] arm: user_regset: iWMMXt in core dumps
Message-ID: <20090427224355.GD5033@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Roland McGrath <roland@redhat.com>,
	Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com> <20090425001259.CDC92FC3C8@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425001259.CDC92FC3C8@magilla.sf.frob.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 05:12:59PM -0700, Roland McGrath wrote:
> This enables dumping the iWMMXt state in ELF core dumps if it was used.
> It gets its own note of the new type NT_ARM_WMMX.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

Are these note definitions centrally defined anywhere? I looked at the
include/elf/common.h in gdb, but it seemed fairly similar to linux/elf.h.

Both sh and mips would benefit from a note type for DSP registers. Would
something like an NT_PRDSPREG be accetable for this? Also, the note
definitions seem to have hopped from 4 to 6, is there a definition for 5,
or can that be used for a DSP register note type?

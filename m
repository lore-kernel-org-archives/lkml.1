Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954Ab0AWQcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0AWQcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 11:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683Ab0AWQcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 11:32:12 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:41193 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0AWQcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 11:32:12 -0500
Date: Sat, 23 Jan 2010 17:31:58 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: cleanup switches with cases that can be merged
Message-ID: <20100123163158.GB5570@linux-mips.org>
References: <4B56475F.8070608@gmail.com>
 <4B56641E.1030803@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B56641E.1030803@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 06:02:06PM -0800, David Daney wrote:

> This patch should be split up.
> 
> Octeon, PowerTV, and IP32 are all different architectures.  They
> should be in their own patches.
> 
> The two math-emu parts could probably go together.
> 
> cpu-probe seems like its own thing.

It's conceptually the same change that's being applied everywhere and the
total size is modest so I'm happy to apply it as just a single patch as is.

> This brings us to the larger question:  This is just code churn.  Is
> it even worthwhile?

This has been discussed many times over and we maintainers have not come to
a final conclusion on this type of patches.  I tend to apply this sort of
patches anyway but treat them as low priority.

  Ralf

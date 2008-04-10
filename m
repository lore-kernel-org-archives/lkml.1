Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbYDJPVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbYDJPVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbYDJPVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:21:13 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55642 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612AbYDJPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:21:13 -0400
Date: Thu, 10 Apr 2008 09:21:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Martin Mares <mj@ucw.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080410152111.GS11962@parisc-linux.org>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz> <mj+md-20080410.140857.3331.nikam@ucw.cz> <20080410151406.GA17051@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410151406.GA17051@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 04:14:06PM +0100, Jamie Lokier wrote:
> Also, can this problem affect programs doing concurrent reads/writes
> using pread/pwrite (or the AIO equivalents)?

pread/pwrite specify an explicit offset and do not change the file
offset, so there's no way they can be affected.  See the manpage.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

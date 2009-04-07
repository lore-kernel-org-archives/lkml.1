Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZDGIuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZDGIuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZDGIu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:50:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:49132 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZDGIu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:50:26 -0400
Date: Tue, 7 Apr 2009 10:50:23 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Peter Hallberg <hallberg68@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intepreting an oops
Message-ID: <20090407085023.GB26300@tiehlicka.suse.cz>
References: <COL116-W68F0521CACD2E1656E8D1BDA870@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <COL116-W68F0521CACD2E1656E8D1BDA870@phx.gbl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 05-04-09 14:48:19, Peter Hallberg wrote:
> 
> How does one translate the offset in the function to a line number in the source code?
> [  218.418473] Call Trace:
> [  218.418484]  [] :nnpfs:nnpfs_writepage+0xab/0x230
> [  218.418498]  [] __writepage+0xa/0x30
> [  218.418503]  [] write_cache_pages+0x250/0x340
> [  218.418509]  [] __writepage+0x0/0x30
> [  218.418522]  [] generic_file_aio_write+0x6f/0xd0
> [  218.418540]  [] do_writepages+0x2b/0x40
> [  218.418545]  [] __filemap_fdatawrite_range+0x52/0x60
> [  218.418558]  [] filemap_write_and_wait+0x35/0x50
> [  218.418570]  [] :nnpfs:nnpfs_fsync_int+0x47/0x1b0
> [  218.418599]  [] :nnpfs:nnpfs_release_file+0x9d/0xc0
> [  218.418608]  [] filp_close+0x33/0x90
> [  218.418615]  [] sys_close+0x9f/0x100
> [  218.418622]  [] system_call+0x7e/0x83
> 

addr2line is also an option
-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

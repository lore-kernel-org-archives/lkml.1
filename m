Return-Path: <linux-kernel-owner+w=401wt.eu-S1751655AbZDMMLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbZDMMLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 08:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbZDMMLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 08:11:06 -0400
Received: from mail001.aei.ca ([206.123.6.130]:41358 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZDMMLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 08:11:05 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: How movable is zone movable?
Date: Mon, 13 Apr 2009 08:10:58 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-crc; KDE/4.2.2; x86_64; ; )
References: <200904121129.09851.edt@aei.ca> <20090413095924.GA15333@csn.ul.ie> <20090413100440.GB15333@csn.ul.ie>
In-Reply-To: <20090413100440.GB15333@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904130810.59230.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 April 2009 06:04:40 you wrote:
> On Mon, Apr 13, 2009 at 10:59:25AM +0100, Mel Gorman wrote:
> > > # huge_pages with movablecore set to 3G
> > 
> > How big did you make the movable zone and what is the hugepage size?
> 
> Scratch that question, I missed you said it was 3G. Are pages being
> mlocked()?

Looks like there are mlocked pages.  What stopped the patches to allow these pages
to be migrated?

TIA
Ed

(from /proc/zoneinfo)
Node 0, zone  Movable
  pages free     35321
        min      858
        low      1072
        high     1287
        scanned  0 (aa: 2 ia: 0 af: 0 if: 0)
        spanned  786432
        present  775680
    nr_free_pages 35321
    nr_inactive_anon 29383
    nr_active_anon 82452
    nr_inactive_file 376826
    nr_active_file 219586
    nr_unevictable 816
    nr_mlock     816
    nr_anon_pages 110648
    nr_mapped    28364
    nr_file_pages 598492
    nr_dirty     131
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 95
    nr_writeback_temp 0
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 7
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 7
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 2
              count: 14
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         1441792
  inactive_ratio:    4

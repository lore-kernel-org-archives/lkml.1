Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZHNE5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZHNE5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 00:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZHNE5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 00:57:34 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56333 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZHNE5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 00:57:33 -0400
Date: Fri, 14 Aug 2009 13:57:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: graff.yang@gmail.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] mm/nommu.c: check read permission in validate_mmap_request()
Message-ID: <20090814045734.GB9570@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, graff.yang@gmail.com,
	dhowells@redhat.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org
References: <1250219961-11681-1-git-send-email-graff.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250219961-11681-1-git-send-email-graff.yang@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 11:19:21AM +0800, graff.yang@gmail.com wrote:
> From: Graff Yang <graff.yang@gmail.com>
> 
> According to the POSIX (1003.1-2008), the file shall have been opened
> with read permission, regardless of the protection options specified.
> The ltp test cases mmap06/07 need this.
> 
> Signed-off-by: Graff Yang <graff.yang@gmail.com>

Looks good. This brings it more in line with MMU Linux anyways, so it's
worthwhile regardless.

Acked-by: Paul Mundt <lethal@linux-sh.org>

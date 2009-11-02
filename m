Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbZKBSpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbZKBSpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZKBSpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:45:15 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:41836 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbZKBSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:45:11 -0500
Date: Mon, 2 Nov 2009 10:44:59 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/27] BKL: Remove BKL from configfs
Message-ID: <20091102184458.GA28491@mail.oracle.com>
Mail-Followup-To: Jan Blunck <jblunck@suse.de>,
	linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
	linux-kernel@vger.kernel.org
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
 <1257156307-24175-14-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257156307-24175-14-git-send-email-jblunck@suse.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AEF28B5.0156:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:04:53AM +0100, Jan Blunck wrote:
> BKL is only used in fill_super. It is safe to remove it.
> 
> Since this filesystem uses get_sb_single(), fill_super is only called once.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>

Acked-by: Joel Becker <joel.becker@oracle.com>

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

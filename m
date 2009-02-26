Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZBZMn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZBZMn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbZBZMnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:43:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46753 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbZBZMnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:43:49 -0500
Date: Thu, 26 Feb 2009 13:43:39 +0100
From: Karel Zak <kzak@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
Message-ID: <20090226124339.GA10548@nb.net.home>
References: <1235600698-6446-1-git-send-email-matthew@wil.cx> <49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net> <49A5D55A.9080402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A5D55A.9080402@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 03:33:46PM -0800, H. Peter Anvin wrote:
> virtually every partition table format contains a sector size  
> dependency

 Is it true that "every partition table format"? I see in
 fs/partitions/ that only ibm.c and msdos.c care about a sector size.
 It seems that the others formats are based on 512 sectors only.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>

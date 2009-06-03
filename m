Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbZFCKPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbZFCKPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbZFCKPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:15:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37807 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbZFCKPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:15:46 -0400
Subject: Re: linux-next: gfs2 tree build warning
From: Steven Whitehouse <swhiteho@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Abhijith Das <adas@redhat.com>
In-Reply-To: <20090603154031.3652281b.sfr@canb.auug.org.au>
References: <20090603154031.3652281b.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 03 Jun 2009 11:15:36 +0100
Message-Id: <1244024136.29604.596.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-06-03 at 15:40 +1000, Stephen Rothwell wrote:
> Hi Steven,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> fs/gfs2/file.c: In function 'gfs2_flock':
> fs/gfs2/file.c:697: warning: unused variable 'ip'
> 
> Introduced by commit a12af1ebe675e85831fde3c4d0908fc3b0908b7a ("GFS2:
> smbd proccess hangs with flock() call") which removed the last usage of
> 'ip'.
> 

Thanks for letting me know. There is a fix in the -nmw tree now,

Steve.



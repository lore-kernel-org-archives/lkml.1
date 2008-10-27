Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYJ0TC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYJ0TC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYJ0TB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:01:59 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:34272 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbYJ0TB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:01:58 -0400
Subject: Re: fs/nfs_common/Makefile: fix the C file name
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <20081027170737.GA1027@hack.voiplan.pt>
References: <20081027170737.GA1027@hack.voiplan.pt>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Oct 2008 15:01:53 -0400
Message-Id: <1225134113.14242.28.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8BIT
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, MISSING_SUBJECT=0.001,NO_RECEIVED=-0.001, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 966D8A30A0E56C938884E6A2CC1CE2C651C63051
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 148 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 17:07 +0000, Américo Wang wrote:
> There's no file named 'nfs_acl.c' in that directory, it is 'nfsacl.c'.
> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: J. Bruce Fields <bfields@fieldses.org>
> 
> ---
> diff --git a/fs/nfs_common/Makefile b/fs/nfs_common/Makefile
> index f689ed8..5cb60c5 100644
> --- a/fs/nfs_common/Makefile
> +++ b/fs/nfs_common/Makefile
> @@ -2,6 +2,6 @@
>  # Makefile for Linux filesystem routines that are shared by client and server.
>  #
>  
> -obj-$(CONFIG_NFS_ACL_SUPPORT) += nfs_acl.o
> +obj-$(CONFIG_NFS_ACL_SUPPORT) += nfsacl.o
>  
>  nfs_acl-objs := nfsacl.o

NAK. The existing line is correct because the _module_ is called
nfs_acl.ko.

  Trond


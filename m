Return-Path: <linux-kernel-owner+w=401wt.eu-S1765593AbXGWQIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765593AbXGWQIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764186AbXGWQHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:07:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31438 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759151AbXGWQHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:07:34 -0400
Message-ID: <46A4D1DE.6070702@oracle.com>
Date: Mon, 23 Jul 2007 12:05:50 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture team, Oracle USA
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix broken handling of port=... in NFS option parsing
References: <20070722095906.GX21668@ftp.linux.org.uk>
In-Reply-To: <20070722095906.GX21668@ftp.linux.org.uk>
Content-Type: multipart/mixed;
 boundary="------------030400090603030305090707"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030400090603030305090707
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

ACK.

Al Viro wrote:
> 	Obviously broken on little-endian; fortunately, the option is
> not frequently used...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index b34b7a7..b2a851c 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -732,7 +732,7 @@ static int nfs_parse_mount_options(char *raw,
>  				return 0;
>  			if (option < 0 || option > 65535)
>  				return 0;
> -			mnt->nfs_server.address.sin_port = htonl(option);
> +			mnt->nfs_server.address.sin_port = htons(option);
>  			break;
>  		case Opt_rsize:
>  			if (match_int(args, &mnt->rsize))

--------------030400090603030305090707
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------030400090603030305090707--

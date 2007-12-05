Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbXLER4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbXLER4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbXLERzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:55:40 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57085 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbXLERzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:55:38 -0500
Date: Wed, 5 Dec 2007 09:55:16 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove nonsense force-casts from ocfs2
Message-ID: <20071205175516.GM28607@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20071205084647.GH8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205084647.GH8181@ftp.linux.org.uk>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 08:46:47AM +0000, Al Viro wrote:
> 	endianness annotations in networking code had been in place for
> quite a while; in particular, sin_port and s_addr are annotated as
> big-endian.  Code in ocfs2 had __force casts added apparently to shut the
> sparse warnings up; of course, these days they only serve to *produce*
> warnings for no reason whatsoever...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Mark Fasheh <mark.fasheh@oracle.com>

Thanks a lot Al.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

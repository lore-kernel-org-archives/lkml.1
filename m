Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbZHYS71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbZHYS71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932079AbZHYS7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:59:25 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:24116 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbZHYS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:59:21 -0400
Date: Tue, 25 Aug 2009 11:58:39 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de,
       linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 05/17] ocfs2: Use __generic_file_aio_write instead of
 generic_file_aio_write_nolock
Message-ID: <20090825185839.GB9812@mail.oracle.com>
Mail-Followup-To: Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, hch@lst.de,
	linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
 <1250875447-15622-6-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250875447-15622-6-git-send-email-jack@suse.cz>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4A94347E.00B7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 07:23:55PM +0200, Jan Kara wrote:
> Use the new helper. We have to submit data pages ourselves in case of O_SYNC
> write because __generic_file_aio_write does not do it for us. OCFS2 developpers
> might think about moving the sync out of i_mutex which seems to be easily
> possible but that's out of scope of this patch.
> 
> CC: ocfs2-devel@oss.oracle.com
> CC: Joel Becker <joel.becker@oracle.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Joel Becker <joel.becker@oracle.com>
 

-- 

"The real reason GNU ls is 8-bit-clean is so that they can
 start using ISO-8859-1 option characters."
	- Christopher Davis (ckd@loiosh.kei.com)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

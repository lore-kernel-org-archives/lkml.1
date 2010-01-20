Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988Ab0ATIiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab0ATIiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892Ab0ATIiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:38:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0ATIiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:38:21 -0500
Date: Wed, 20 Jan 2010 03:38:18 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] scsi: add scsi trace core function and put trace
	points
Message-ID: <20100120083818.GB5020@infradead.org>
References: <4B56A621.2070301@jp.fujitsu.com> <yq1ockpky1h.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1ockpky1h.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 02:58:34AM -0500, Martin K. Petersen wrote:
> >>>>> "Kei" == Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com> writes:
> 
> +	TP_printk("host_no=%u channel=%u id=%u lun=%u cmnd=(%s %s raw=%s) "
>                               ^^^^^^^^^^
> 
> I'm not sure anybody cares about channels in this millennium so that may
> be a waste of space.

IT;s still used for adressing things internally.  E.g. in sas we
typically map ports to them.


Return-Path: <linux-kernel-owner+w=401wt.eu-S968350AbXEHPwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968350AbXEHPwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968266AbXEHPwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:52:00 -0400
Received: from www.osadl.org ([213.239.205.134]:39596 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967613AbXEHPv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:51:58 -0400
Subject: Re: [PATCH 1/2] LogFS proper
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
In-Reply-To: <Pine.LNX.4.61.0705081439270.17280@yvahk01.tjqt.qr>
References: <20070507215913.GA15054@lazybastard.org>
	 <20070507220036.GB15054@lazybastard.org>
	 <1178608950.3042.273.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0705081439270.17280@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Tue, 08 May 2007 17:54:41 +0200
Message-Id: <1178639681.3042.334.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 14:46 +0200, Jan Engelhardt wrote:
> >> +static int __logfs_readdir(struct file *file, void *buf, filldir_t filldir)
> >> +{
> >> +		err = read_dir(dir, &dd, pos);
> >> +		if (err == -EOF)
> >> +			break;
> >
> >	-EOF results in a return code 0 ?
> 
> Results in a return code -256.

Really ? It breaks out of the loop and returns 0 !

> +	}
> +
> +	file->f_pos = pos + IMPLICIT_NODES;
> +	return 0;

	tglx



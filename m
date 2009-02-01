Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZBAQhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZBAQhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZBAQhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:37:15 -0500
Received: from verein.lst.de ([213.95.11.210]:49252 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZBAQhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:37:13 -0500
Date: Sun, 1 Feb 2009 17:36:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       hpa@zytor.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 3/5] Move common mknod_ptmx() calls into caller
Message-ID: <20090201163653.GG3416@lst.de>
References: <20090129064259.GA23160@us.ibm.com> <20090129064643.GD23160@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129064643.GD23160@us.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 10:46:43PM -0800, Sukadev Bhattiprolu wrote:
> 
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 28 Jan 2009 18:54:25 -0800
> Subject: [RFC][PATCH 3/5] Move common mknod_ptmx() calls into caller
> 
> We create 'ptmx' node in both single-instance and multiple-instance
> mounts. So devpts_get_sb() can call mknod_ptmx() once rather than
> have both modes calling mknod_ptmx() separately.

Looks good.


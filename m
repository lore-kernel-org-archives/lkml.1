Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbXFTCSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbXFTCSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 22:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbXFTCSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 22:18:32 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:53740 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866AbXFTCSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 22:18:31 -0400
Date: Tue, 19 Jun 2007 22:18:26 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 2/3]integrity: IMA as an integrity service provider
In-Reply-To: <1182199326.8577.6.camel@localhost.localdomain>
Message-ID: <Line.LNX.4.64.0706192217040.19316@localhost.localdomain>
References: <1182199326.8577.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Mimi Zohar wrote:


> +/* what could we exclude
> + *   - non-executable/non-library files ?
> + *   - /proc /dev ?
> + * Only measure files opened for read-only or execute
> + */
> +static int skip_measurement(struct inode *inode, int mask)
> +{
> +	if ((inode->i_sb->s_magic == PROC_SUPER_MAGIC) ||
> +	    (inode->i_sb->s_magic == SYSFS_MAGIC)) {
> +		return 1;	/*can't measure */
> +	}

I'm pretty sure you should skip measurement for many more pseudo 
filesystems than this.



- James
-- 
James Morris
<jmorris@namei.org>

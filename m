Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbXFESaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbXFESaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbXFESaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:30:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:39791 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbXFESaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=i+8lIKIzKSQ9T4Lq/uDDC8lqV7ITKiokfAdFsJIJs6oqiU6pi/t6Gs5N6jJes0v/y0q1muqFP7yaOuaCBOaU/vdvJa/Dj4YJ8dGYIx+P9+DktFLgktJHOzFMN5GKgPXk9edLOBLVIAIOG/XP1AF8A2mgnPNCioRKUDNrrdsxnhw=
Date: Tue, 5 Jun 2007 22:28:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UDF: coding style conversion - lindent fixups 2
Message-ID: <20070605182850.GD8398@cvg>
References: <20070605180335.GC8398@cvg> <1181067646.23941.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181067646.23941.31.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Joe Perches - Tue, Jun 05, 2007 at 11:20:46AM -0700]
| On Tue, 2007-06-05 at 22:03 +0400, Cyrill Gorcunov wrote:
| > -			    cpu_to_le32(epos.offset -
| > -					sizeof(struct allocExtDesc));
| > -			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
| > -			    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
| > +				cpu_to_le32(epos.offset -
| > +					    sizeof(struct allocExtDesc));
| > +			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
| > +			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
| 
| Please do not move logical operators or tests from
| "beginning of next line" to "end of line".
| 
| It's coder taste and there is no style guide consensus for this.
| 
| cheers,
| 
| Joe
| 

Actually a such conversion were made by Lindent - not coder...
See for original truncate.c in current Linus's tree

		Cyrill


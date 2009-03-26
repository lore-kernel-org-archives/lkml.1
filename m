Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbZCZVMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbZCZVMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 17:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbZCZVMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 17:12:42 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43759 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbZCZVMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 17:12:42 -0400
Date: Thu, 26 Mar 2009 15:12:24 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] config: Make need for SCSI_CDROM clearer
Message-ID: <20090326211224.GF8014@parisc-linux.org>
References: <20090326205445.5498.17522.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326205445.5498.17522.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 08:54:51PM +0000, Alan Cox wrote:
> -	  If you want to use a SCSI or FireWire CD-ROM under Linux,
> +	  If you want to use a SCSI, FireWire or ATAPI CD-ROM under Linux,
>  	  say Y and read the SCSI-HOWTO and the CDROM-HOWTO at

Should probably add USB drives here too, since they seem to be getting
more common:

+	  If you want to use a SCSI, FireWire, USB or ATAPI CD-ROM under
+	  Linux, say Y and read the SCSI-HOWTO and the CDROM-HOWTO at

I don't think we need to mention Fibre Channel here ... I'm not
convinced there are any FC CD-ROM drives in existence, and if there are,
they're sufficiently uncommon to not produce bug reports.

Also, should we perhaps add DVD drives here?

+	  If you want to use a CD or DVD drive attached to your computer
+	  by SCSI, FireWire, USB or ATAPI, say Y and read the SCSI-HOWTO
+	  and the CDROM-HOWTO at <http://www.tldp.org/docs.html#howto>.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

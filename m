Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbYBASeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbYBASeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbYBASeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:34:24 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49156 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbYBASeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:34:23 -0500
Date: Fri, 1 Feb 2008 19:34:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       net-dev-mailing list <netdev@vger.kernel.org>
Subject: Re: [BUILD FAILURE]2.6.24-git10 section type conflict
Message-ID: <20080201183425.GB14759@uranus.ravnborg.org>
References: <20080201182627.GB14251@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201182627.GB14251@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 11:56:27PM +0530, Sudhir Kumar wrote:
> Hi All,
> I found the following kernel build failure for 2.6.24-git10
> on my machine:
> 
>   CC [M]  drivers/scsi/lpfc/lpfc_attr.o
> drivers/net/sis190.c:329: error: sis190_pci_tbl causes a section type
> conflict
> make[2]: *** [drivers/net/sis190.o] Error 1
> make[1]: *** [drivers/net] Error 2
> make[1]: *** Waiting for unfinished jobs....
>   CC [M]  drivers/scsi/lpfc/lpfc_vport.o

Known issue with fix already pushed upstream.
A workaround is to delete __devinitdata from the
corresponding .c (sis190.c) file.

	Sam

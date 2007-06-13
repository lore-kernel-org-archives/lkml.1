Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbXFMRt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbXFMRt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758702AbXFMRtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:49:50 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:50271 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758661AbXFMRtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:49:49 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       gregkh@suse.de, mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
In-Reply-To: <20070613171628.GA5721@martell.zuzino.mipt.ru>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613171628.GA5721@martell.zuzino.mipt.ru>
Content-Type: text/plain
Organization: IBM
Date: Wed, 13 Jun 2007 19:46:13 +0200
Message-Id: <1181756773.29512.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 21:16 +0400, Alexey Dobriyan wrote:
> On Wed, Jun 13, 2007 at 05:06:57PM +0200, holzheu wrote:
> > -CHECK		= sparse
> > -
> > -CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise $(CF)
> > +CHECK		= scripts/kmsg-doc check
> > +CHECKFLAGS	=
> 
> Ick. Don't touch those checking kernel with sparse.

Of course we don't want to have that in the vanilla kernel. I just
wanted to show, how the checker tool has to be used.

Michael


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZBCQg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZBCQg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZBCQgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:36:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZBCQgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:36:17 -0500
Date: Tue, 3 Feb 2009 17:36:13 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@bogon.housecafe.de
To: Alex <eosyop@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kernel] Question about 2.6.28 kernel
In-Reply-To: <1233670928.28905.12.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0902031730140.4084@bogon.housecafe.de>
References: <1233594684.3018.12.camel@localhost.localdomain>  <alpine.DEB.2.00.0902022110290.4084@bogon.housecafe.de> <1233670928.28905.12.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1++8iWVsgS+gx8fE06YuuCvGrSMnjpDMRVzzff
 cvB3NMDd622V1V/Vvhhbj4Y8Rrk2lF+cSBES8EcGonGoBcC07o
 Ak1amlRkib5BAAU5FqpBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Alex wrote:
> Thanks for reply. Here is the post, it appears when i try to write into
> kernel memory.  :

Thanks for the Oops. But again, you might have to share a little more 
information, either here on lkml on with the security team. I'm no kernel 
developer but I wonder *what exactly* are you doing to produce this Oops.

> Pid: 3887, comm: insmod Not tainted (2.6.28 #2) HP Pavilion dv2700

Which module did you just insert? Is it your own trying to write to kernel 
memory? Can we see the source of that? However, since you're are root 
anyway to load this module, you can of course do all kinds of shenanigans 
to memory and the kernel might just Oops rightfully so.

Christian.
-- 
BOFH excuse #17:

fat electrons in the lines

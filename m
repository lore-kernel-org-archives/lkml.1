Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZCOSNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZCOSNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbZCOSNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:13:19 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:52813 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbZCOSNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:13:18 -0400
Date: Sun, 15 Mar 2009 18:13:15 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: smart cache. ist is possible?
Message-ID: <20090315181315.GA4369@silver.sucs.org>
References: <49BD1EB7.6080109@fisher-privat.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BD1EB7.6080109@fisher-privat.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Mar 15, 2009 at 04:28:55PM +0100, Alexey Fisher wrote:
> I found for my self how great is cache in linux. If read one file from
> disk, so i don't need to do it second time, chace will do the job. It
> speed up thing greatly. But i found it not working with realy big files.
> Like i have 4GB RAM, so if i read a file like 4.6GB, cache won't work.

Watch out - if you are doing cache tests you really want to be using
drop_caches ( http://linux-mm.org/Drop_Caches ) before your "cold" runs
so you can be sure that the cache really was empty before you started...

-- 
Sitsofe | http://sucs.org/~sits/

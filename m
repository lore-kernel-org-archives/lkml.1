Return-Path: <linux-kernel-owner+w=401wt.eu-S1765611AbXJQPqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765611AbXJQPqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbXJQPqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:46:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55667 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbXJQPqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:46:32 -0400
Date: Wed, 17 Oct 2007 13:43:48 +0200
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-git11 compile issues
Message-ID: <20071017114348.GA18693@ahaupt-debian-vm.localdomain>
References: <1192635199.14504.2.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192635199.14504.2.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andre Haupt <andre@bitwigglers.org>
X-Provags-ID: V01U2FsdGVkX18QEUsa+CqP09byP/ms0FeXBXvrj0eEpaf7PHc
 VlNnK3oGixNuQSeYDwOakYd6cZuvgRxHMpXT/I95sGEo4MkTd7
 ey4jC9C2RI11NMRFdNceQVDOsXtoZ/yk+hvKqfEYm0=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 08:33:18AM -0700, Badari Pulavarty wrote:
> Known issue ?

I saw that too after a git pull a couple of days ago.
The following worked for me:

make mrproper
cp /proc/config.gz .config.gz (i was running 2.6.23 release kernel)
gunzip .config.gz
make silentoldconfig
make

regards,

Andre


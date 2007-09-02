Return-Path: <linux-kernel-owner+w=401wt.eu-S933723AbXIBKaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723AbXIBKaB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 06:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXIBK3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 06:29:52 -0400
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:30611 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbXIBK3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 06:29:51 -0400
Date: Sun, 2 Sep 2007 12:28:00 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.3
Message-ID: <20070902102800.GA11473@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	Arkadiusz Miskiewicz <arekm@pld-linux.org>, git@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <7vodglr32i.fsf@gitster.siamese.dyndns.org> <fbdt3q$lcf$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbdt3q$lcf$1@sea.gmane.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-RZG-AUTH: z4gQVF2k5XWuW3CcuQaFzAPiog==
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arkadiusz Miskiewicz, Sun, Sep 02, 2007 10:43:38 +0200:
> *** t0001-init.sh ***
> * FAIL 1: plain
> 
>                 (
>                         unset GIT_DIR GIT_WORK_TREE &&
>                         mkdir plain &&
>                         cd plain &&
>                         git init
>                 ) &&
>                 check_config plain/.git false unset
> 
> *   ok 2: plain with GIT_WORK_TREE
> * FAIL 3: plain bare
> 
>                 (
>                         unset GIT_DIR GIT_WORK_TREE GIT_CONFIG &&
>                         mkdir plain-bare-1 &&
>                         cd plain-bare-1 &&
>                         git --bare init
>                 ) &&
>                 check_config plain-bare-1 true unset
> 

Do you have bash-2.05b as /bin/sh ?


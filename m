Return-Path: <linux-kernel-owner+w=401wt.eu-S1759159AbYBESS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159AbYBESS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbYBESSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:18:09 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58502 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758892AbYBESSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:18:07 -0500
Subject: Re: aic7xxx build failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20080205174024.GE505@cs181133002.pp.htv.fi>
References: <20080205174024.GE505@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 12:18:04 -0600
Message-Id: <1202235484.3133.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-05 at 19:40 +0200, Adrian Bunk wrote:
> Commit 8891fec65ac5b5a74b50c705e31b66c92c3eddeb broke aic7xxx 
> compilation:
> 
> <--  snip  -->
> 
> $ make O=../out/x86-full
> ...
>   SHIPPED drivers/scsi/aic7xxx/aic79xx_seq.h
>   SHIPPED drivers/scsi/aic7xxx/aic79xx_reg.h
>   CC      drivers/scsi/aic7xxx/aic79xx_core.o
> gcc: drivers/scsi/aic7xxx/aic79xx_core.c: No such file or directory
> gcc: no input files
> make[4]: *** [drivers/scsi/aic7xxx/aic79xx_core.o] Error 1

Could you run this with V=1 to get us a verbose output of what the exact
files gcc is failing on are?

Thanks,

James



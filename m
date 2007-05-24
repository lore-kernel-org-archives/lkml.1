Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbXEXSgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbXEXSgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbXEXSf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:35:57 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbXEXSf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:35:57 -0400
Date: Thu, 24 May 2007 11:35:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Fix possible UDF data corruption
Message-Id: <20070524113550.d09dbf9e.akpm@linux-foundation.org>
In-Reply-To: <20070524172017.GA19852@cvg>
References: <20070524165935.GB19709@duck.suse.cz>
	<20070524172017.GA19852@cvg>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 21:20:17 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Jan Kara - Thu, May 24, 2007 at 06:59:35PM +0200]
> |   Hi Andrew,
> | 
> |   attached patch fixes possible data corruption in UDF - this bug was actually
> | introduced by one of my fixes :-( and should (if possible) go to Linus before
> | 2.6.22 is out (that's why I'm diffing against Linus's tree and not the
> | latest changes in -mm tree)... Thanks.
> | 
> | 								Honza
> | 
> | -- 
> | Jan Kara <jack@suse.cz>
> | SuSE CR Labs
> 
> Jan should I wait until Andrew has your patches included and
> only then (having taken into account your patches) produce my
> conversion?
> 

yes please - bugfixes come first.

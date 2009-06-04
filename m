Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbZFDUUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbZFDUUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZFDUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:19:56 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35102 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZFDUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:19:55 -0400
Date: Thu, 4 Jun 2009 22:22:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 2/6] headers_check fix: ia64, fpswa.h
Message-ID: <20090604202212.GD13892@uranus.ravnborg.org>
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam> <1244118599.5172.31.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244118599.5172.31.camel@ht.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 05:59:59PM +0530, Jaswinder Singh Rajput wrote:
> 
> fix the following 'make headers_check' warning:
> 
>   usr/include/asm-ia64/fpswa.h:71: extern's make no sense in userspace
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Tony - is this file really used from userspace.
Looking at the definitions I think not.

I not then the real fix is to unexport it.

	Sam

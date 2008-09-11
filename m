Return-Path: <linux-kernel-owner+w=401wt.eu-S1752124AbYIKFiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbYIKFiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 01:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYIKFh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 01:37:57 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:28787 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYIKFh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 01:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=eNodjybkyZLlTx32/Sj4pbkZv+09UOSFOF2xZKZ09IF5NzmhnRuqkIr0zRw71v+9YX
         Vow/xhZhn21SV5nCJw3V79SK55xzJFnVVdJHgu8l53N+VuwyJwxypqhF4OlY8uivUzrO
         xXHUcXn/pPG3xgc5s7G+DvDlNYClngv1OvLv0=
Date: Thu, 11 Sep 2008 09:31:09 +0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       aabdulla@nvidia.com, jgarzik@pobox.com
Subject: Re: forcedeth: option to disable 100Hz timer (try 2)
Message-ID: <20080911093109.2cc34135@laska>
In-Reply-To: <20080910221947.94409642.akpm@linux-foundation.org>
References: <fa.iCGOiwuSYhYKpu85Kihny1t9YbA@ifi.uio.no>
	<fa.4uZtuq0waBlpfBb/4OLq4bM5Pj8@ifi.uio.no>
	<48C863CC.3010902@shaw.ca>
	<20080910173630.d0d38697.akpm@linux-foundation.org>
	<48C89D9F.5080404@shaw.ca>
	<20080910221947.94409642.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 22:19:47 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 10 Sep 2008 22:25:03 -0600 Robert Hancock <hancockr@shaw.ca> wrote:
> 
> > Enabling by 
> > default and disabling after a TX done interrupt was received would 
> > likely be a better approach
> 
> yup, that's far better.

How it will work, if network cable unpluged? This is quite often situation
for laptop with wifi?

> 
> > But it's quite likely that at least some of the 
> > chipsets that this driver supports don't need this timer nonsense at all
> 
> Well yes.  If all the chipsets need the timer then there's nothing we
> can do to improve it.
> 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbZEMFjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbZEMFjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZEMFjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:39:05 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:39767 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZEMFjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xi3+MHB8VPJ6w46ecCmHZxPAr9tI8ZKhel3EcdSpY3kTCUEgfrJswdxGEqtqQBF/F2
         igCfBGhEUSyL+nxvI0qDwZMKeYjM5jsUAy9Rc0P8ZYyZwcG+JY+xkfivbHZIMTJsp5c+
         HpTIltIIvzqLACR7Q+lZVND6/UypZKeTgBqLU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0905121720430.24066@qirst.com>
References: <4A05269D.8000701@kernel.org> <4A052721.4010201@kernel.org>
	 <alpine.DEB.1.10.0905112126410.28512@qirst.com>
	 <4A089E53.8010106@kernel.org>
	 <alpine.DEB.1.10.0905121658140.14226@qirst.com>
	 <4A09AEFB.4070808@kernel.org>
	 <alpine.DEB.1.10.0905121720430.24066@qirst.com>
Date: Tue, 12 May 2009 22:39:04 -0700
Message-ID: <86802c440905122239h7a187627i6158b79045ba1024@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: add numa_move_cpus_to_node
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 2:21 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Tue, 12 May 2009, Yinghai Lu wrote:
>
>> or let user util do that? aka before hotadd mem to that node, use /sys to bring
>> the cpu offine and put the cpus online after mem is added ?
>
> Ok then we wont need the kernel.
>
so i recored this OK as one Reviewed-by or Acked-by ?

YH

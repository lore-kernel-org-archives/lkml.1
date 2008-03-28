Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYC1Fdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYC1Fdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 01:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYC1Fd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 01:33:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:1514 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYC1Fd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 01:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mEWFBTSjAkRcaHziTm1AIusnJNBlqhtLcsiY8GIJYrxE6SCaY+2QwYWWU6IoHuFb8EwA5oI0wh4kQPmrMwiElagi3RDg757V9FzGO9oRSCiAZvhpjF00Sp6G6YbSyx5Kee2zbOEEIFTJxMHfGM3h+qAyYt41L8t1br0sVorcnAI=
Message-ID: <86802c440803272233ved9c1d6w44f8722c85cf4c62@mail.gmail.com>
Date: Thu, 27 Mar 2008 22:33:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 0/4] x86_64 boot -v2: Add linked listof struct setup_data to boot protocol
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, "Paul Jackson" <pj@sgi.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1206672578.13404.21.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206672578.13404.21.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 7:49 PM, Huang, Ying <ying.huang@intel.com> wrote:
> This patchset adds the linked list of struct setup_data to boot
>  protocol. This is needed by EDD information and some SGI machine with
>  E820 entry number > 128.

interesting, that 512nodes/4096 box physics memory is not continuous?

YH

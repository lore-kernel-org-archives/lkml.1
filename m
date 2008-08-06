Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYHFQff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYHFQff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYHFQe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:34:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:56189 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbYHFQez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AjWJGrkmfjj1kt7RPDvHvQBqoSmVC3Ph3JiXW7ABDJlRbj+H8Xnp0ks4+vAtBgkJHd
         Lcb0sNQW+Oi8PjqgefaWyJKuFG5swb+uVIX+FR5PZtZRqqDFxFAGXlTmnAV9LuASc62P
         fHG17HaLlpvo+YY36A8yBI8fxAKLUKmg+3BpU=
Message-ID: <b6a2187b0808060934j4b1c5691pf0fd722bb5fd5864@mail.gmail.com>
Date: Thu, 7 Aug 2008 00:34:52 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "David Miller" <davem@davemloft.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440808060913p327da9dfr7a96ef6676cd0295@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
	 <86802c440808060913p327da9dfr7a96ef6676cd0295@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 12:13 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> actually x86_pc is one mode of genericarch..., genericarch already
> could detect pc, bigsmp, and numaq, es7000, bigsmp, visew..

It seems to get "sparse mem", NUMA must be set first, but this is not
required for X86_PC.


> in the dmesg when booting x86_pc only, we already have warning to let
> you set bigsmp if you have 8 more cpus.

With more than 8 CPUs and upon boot up and hangs,  Shift+PgUp does not
work, so it's not possible to view console messages except those on
the current page, so I guess I missed that hint.

Jeff.

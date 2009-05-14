Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZENU7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZENU7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZENU6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:58:51 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:58393 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbZENU6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:58:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fhh4olZcRDEMDNIcoCgKeN/PKQ3a/kBxpn4v9xAQfR0DD6K+Up7v7WRLSdwpBt2pIm
         iTDR8b6zWbQQlAh4Or3LMpQM7wD+jVR8m1syXYNtxNF8MwAxtG9d9z3jPoD53trXNFTQ
         1dW0NnuyNLqiONW1GvtLZ1umwBF22bi1j4yiU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0905141533550.1381@qirst.com>
References: <4A05269D.8000701@kernel.org> <4A052721.4010201@kernel.org>
	 <alpine.DEB.1.10.0905112126410.28512@qirst.com>
	 <4A089E53.8010106@kernel.org>
	 <alpine.DEB.1.10.0905121658140.14226@qirst.com>
	 <4A09AEFB.4070808@kernel.org>
	 <alpine.DEB.1.10.0905121720430.24066@qirst.com>
	 <86802c440905122239h7a187627i6158b79045ba1024@mail.gmail.com>
	 <alpine.DEB.1.10.0905141533550.1381@qirst.com>
Date: Thu, 14 May 2009 13:58:51 -0700
Message-ID: <86802c440905141358p1274e389q135e0d766f02cb21@mail.gmail.com>
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

On Thu, May 14, 2009 at 12:34 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Tue, 12 May 2009, Yinghai Lu wrote:
>
>> so i recored this OK as one Reviewed-by or Acked-by ?
>
> Well why do we need this functionality in the kernel if offlining and
> onlining the cpu again will properly allocate the kernel metadata?

ok, you are right, for x86 64 bit, srat_detect_node will call
numa_set_node when online the cpu again.

we don't this patch.

YH

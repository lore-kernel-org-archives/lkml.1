Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZENTf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZENTf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZENTfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:35:11 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:41784 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752716AbZENTfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:35:10 -0400
Date: Thu, 14 May 2009 15:34:52 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/3] x86: add numa_move_cpus_to_node
In-Reply-To: <86802c440905122239h7a187627i6158b79045ba1024@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0905141533550.1381@qirst.com>
References: <4A05269D.8000701@kernel.org> <4A052721.4010201@kernel.org>  <alpine.DEB.1.10.0905112126410.28512@qirst.com>  <4A089E53.8010106@kernel.org>  <alpine.DEB.1.10.0905121658140.14226@qirst.com>  <4A09AEFB.4070808@kernel.org> 
 <alpine.DEB.1.10.0905121720430.24066@qirst.com> <86802c440905122239h7a187627i6158b79045ba1024@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Yinghai Lu wrote:

> so i recored this OK as one Reviewed-by or Acked-by ?

Well why do we need this functionality in the kernel if offlining and
onlining the cpu again will properly allocate the kernel metadata?



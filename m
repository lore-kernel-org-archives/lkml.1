Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbYCQPNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbYCQPNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYCQPNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:13:31 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:9033 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYCQPNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:13:30 -0400
X-SourceIP: 80.56.237.116
Subject: Re: [PATCH -mm 1/5] list.h: add list_singleton
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       jkenisto@us.ibm.com, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com, prasanna@in.ibm.com, shaohua.li@intel.com,
       davem@davemloft.net, fche@redhat.com
In-Reply-To: <47DE8870.1020503@redhat.com>
References: <47DAE2C4.2060303@redhat.com>
	 <20080314140007.a7b495d7.akpm@linux-foundation.org>
	 <47DAFAA2.20302@redhat.com> <1205620596.6422.8.camel@lappy>
	 <47DE8870.1020503@redhat.com>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 16:13:18 +0100
Message-Id: <1205766798.8514.318.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-17 at 11:04 -0400, Masami Hiramatsu wrote:
> Hi Peter,
> 
> Peter Zijlstra wrote:
> >>> So I guess we can proceed with your list_singleton(), but I'd just like to
> >>> flag this possible confusion, see what people think..
> > 
> > May I kindly ask to please not use the singleton name like this. It does
> > not implement the singleton pattern and will be a great confusion for
> > everybody who expects it to.
> 
> Indeed.
> 
> I have some other candidates.
> - list_single
> - list_has_one
> - list_one
> 
> Could you tell me which or some other name you recommend?

I think list_has_one() or list_is_singular() are good names, they convey
they are a test for a condition by using a form of be.


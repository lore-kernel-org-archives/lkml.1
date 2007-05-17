Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbXEQPKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbXEQPKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbXEQPKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:10:37 -0400
Received: from smtp.nokia.com ([131.228.20.171]:35600 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850AbXEQPKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:10:36 -0400
Subject: Re: [PATCH] ubi: kill homegrown endian macros
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20070517145653.GA968@lst.de>
References: <20070517143200.GA30850@lst.de>
	 <1179413443.3642.49.camel@sauron>  <20070517145653.GA968@lst.de>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 17 May 2007 18:09:50 +0300
Message-Id: <1179414590.3642.69.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 17 May 2007 15:09:51.0147 (UTC) FILETIME=[6AB9F7B0:01C79895]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 16:56 +0200, Christoph Hellwig wrote:
> On Thu, May 17, 2007 at 05:50:43PM +0300, Artem Bityutskiy wrote:
> > Christoph,
> > 
> > On Thu, 2007-05-17 at 16:32 +0200, Christoph Hellwig wrote:
> > > Kill ubis homegrown endianess handling crap and replace it with
> > > the normal kernel endianess handling.
> > 
> > Err,__be32 and the company are just sparse things, while I have compiler
> > checks with my struct ubi32_t and friends. JFFS2 also uses the same
> > technique. Why do you force me to rely on sparse instead instead of
> > compiler?
> 
> Yes.  Like all other code in the kernel aswell.

Andrew, may I please have your ack that I absolutely have to use __be32
instead of my own types since Christoph tends to provide no explanation
to his requests.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)


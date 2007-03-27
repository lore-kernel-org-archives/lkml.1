Return-Path: <linux-kernel-owner+w=401wt.eu-S965197AbXC0G5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbXC0G5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 02:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965233AbXC0G5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 02:57:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47960 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965197AbXC0G5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 02:57:18 -0400
Date: Tue, 27 Mar 2007 09:57:16 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: "Wu, Bryan" <bryan.wu@analog.com>
cc: Mike Frysinger <vapier.adi@gmail.com>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error
 bug
In-Reply-To: <1174966174.6966.5.camel@roc-desktop>
Message-ID: <Pine.LNX.4.64.0703270955490.32526@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI> 
 <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI> 
 <20070326024143.a226c9b2.akpm@linux-foundation.org>  <1174904637.32691.86.camel@roc-desktop>
 <6017.1174908318@redhat.com>  <6791.1174909459@redhat.com> <11045.1174911764@redhat.com>
  <Pine.LNX.4.64.0703261525370.14158@sbz-30.cs.Helsinki.FI> 
 <22674.1174915478@redhat.com>  <8bd0f97a0703261321h356a849am1ab617f0e732fa67@mail.gmail.com>
 <1174966174.6966.5.camel@roc-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007, Wu, Bryan wrote:
> Agree. MPU of Blackfin can provide some processes protection. But maybe
> at this moment just disable revoke for NOMMU is easier for further
> development. When we provide the MPU stuff, maybe we can enable the
> revoke for NOMMU but MPU arch.

Yeah, MPU should be sufficient for revoke(). Note that mmap() and mummap() 
suffers from the same problem on NOMMU so perhaps we really should do 
CONFIG_MPU.

				Pekka

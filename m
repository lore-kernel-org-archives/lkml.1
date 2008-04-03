Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbYDCPbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbYDCPbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbYDCPbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:31:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:20795 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbYDCPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:31:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=TCHtYSk1ycFh4wQcaACvEGA5NQ+Z8rI2R/uK45HnAP+TteYDt3O00WUQgFLOEZmkz
	xB3IQHpU/jBnVBqpbpZnQ==
Message-ID: <6599ad830804030831h12cac799ub4e1c9a169c722da@mail.gmail.com>
Date: Thu, 3 Apr 2008 08:31:25 -0700
From: "Paul Menage" <menage@google.com>
To: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
Subject: Re: [RFC][patch 3/11][CFQ-cgroup] Introduce cgroup subsystem
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       axboe@kernel.dk, tom-sugawara@ap.jp.nec.com, m-takahashi@ex.jp.nec.com
In-Reply-To: <003001c89532$dae5dd20$90b19760$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>
	 <008001c893db$4e2eccf0$ea8c66d0$@jp.nec.com>
	 <6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com>
	 <003001c89532$dae5dd20$90b19760$@jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 7:31 PM, Satoshi UCHIDA <s-uchida@ap.jp.nec.com> wrote:
>  >
>  > What are these checks for? Cgroups already provides filesystem
>  > permissions to control directory creation, and the "descendant" check
>  > looks like it may have been cut/pasted from the nsproxy subsystem.
>  >
>
>  This code was referred one of io-throttle.
>  Is it not necessary these checks?
>  IF not necessary, remove this code.
>

Yes, I think these checks should be removed. Especially the descendant check.

Paul

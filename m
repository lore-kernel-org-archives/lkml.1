Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYGaRG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYGaRG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYGaRGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:06:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYGaRGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:06:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=bhvTyMMqM5drL0hXwxRoS2wccCk4LZRMeyax1XOLMoHWTXyJ9idSyCGXFLXVxyC8j
	FZrv5lB18c5suLHfY4m0A==
Message-ID: <6599ad830807311006r24e4d325ie505949ad760afd@mail.gmail.com>
Date: Thu, 31 Jul 2008 10:06:41 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] cpuset: make ntasks to be a monotonic increasing value
Cc: "Lai Jiangshan" <laijs@cn.fujitsu.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080731083706.e6bd4acc.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48912FDD.8060006@cn.fujitsu.com>
	 <20080731072355.b582b2d6.pj@sgi.com> <4891B9E0.2090900@cn.fujitsu.com>
	 <20080731083706.e6bd4acc.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 6:37 AM, Paul Jackson <pj@sgi.com> wrote:
> I prefer to only add kernel source code complexity when it is needed
> in practice for correct function or necessary performance.  The above
> more rapid growth of fudge is not needed for either reason, so far as
> I can tell.

That loop really could do with some updates though - currently it
looks at the mm for every task in the cpuset, rather than filtering
duplicate mms from threaded applications.

Paul

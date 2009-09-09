Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbZIIAUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbZIIAUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZIIAUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:20:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZIIAUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:20:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CqGUEF1DnS6fOueoOguH/AN4SJqxFCBrU/YYy4uWl617bkclC/1H0etobvQ41/a3N
	LyCRIcSbleVWzlKKnqtPw==
Date: Tue, 8 Sep 2009 17:20:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jonathan Corbet <corbet@lwn.net>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH] Document flexible arrays
In-Reply-To: <20090908175603.2bb02032@bike.lwn.net>
Message-ID: <alpine.DEB.1.00.0909081714150.6263@chino.kir.corp.google.com>
References: <20090908175603.2bb02032@bike.lwn.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Jonathan Corbet wrote:

> Document the flex_array library.
> 
> A brief document on how to use flexible arrays, derived from an article
> first published on LWN.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Hmm, there are a number of changes in -mm that conflict with the 
description given in this document (element poisoning, DEFINE_FLEX_ARRAY, 
array shrinking, etc).  Perhaps this could be based on the -mm behavior 
and get pushed through Andrew so that it's consistent when merged for 
2.6.32?

Thanks for writing this up, it's very descriptive and understandable.  I 
think there's some question right now about whether flex arrays will be 
very popular given we haven't identified any potential users at the 
moment, though.  Adding this documentation may help in getting new code to 
use it and inspire existing code to convert, so I think it's a good idea 
if flex arrays are indeed here to stay.

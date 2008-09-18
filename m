Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYIRVLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYIRVLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbYIRVLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:11:44 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10765 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754040AbYIRVLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:11:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=G8wLWaCwnZSWOZ5knJCmaAgU9LeK7EcmtO4Xk9mPexHDTuD3cQ9uKiLY8UAXlcCOi
	2efYesxv89hT93Y8dKXhQ==
Message-ID: <33307c790809181411j41a6fc4ev8560a13ed8661ec2@mail.gmail.com>
Date: Thu, 18 Sep 2008 14:11:35 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Populating multiple ptes at fault time
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Hugh Dickens" <hugh@veritas.com>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <48D2BFB8.6010503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D142B2.3040607@goop.org> <48D1625C.7000309@redhat.com>
	 <48D17A93.4000803@goop.org> <48D29AFB.5070409@linux-foundation.org>
	 <48D2A392.6010308@goop.org>
	 <33307c790809181352h14f2cf26kc73de75b939177b5@mail.gmail.com>
	 <48D2BFB8.6010503@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yup, basically you're assuming good locality of reference, but it turns
>> out that (as davej would say) "userspace sucks".
>
> Well, *most* userspace sucks.  It might still be worthwhile to do this when
> userspace is using madvise().

Quite possibly true ... something to benchmark.

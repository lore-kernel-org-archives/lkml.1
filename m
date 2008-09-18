Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYIRWIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYIRWIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbYIRWIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:08:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21695 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754039AbYIRWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:08:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ml+Znif4cZH+TbFr2ZSt1gHBzHzqeXkMNxdbbz+Rc893mUf3hn/CSZXvl2LQQUxra
	Ry6sbq02L0SQBcV+30krA==
Message-ID: <33307c790809181508v2e64c0a4j8f0e93df99673e63@mail.gmail.com>
Date: Thu, 18 Sep 2008 15:08:33 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: Populating multiple ptes at fault time
Cc: "MinChan Kim" <minchan.kim@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Hugh Dickens" <hugh@veritas.com>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <48D2CEF3.6060308@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D142B2.3040607@goop.org> <48D2A392.6010308@goop.org>
	 <33307c790809181352h14f2cf26kc73de75b939177b5@mail.gmail.com>
	 <48D2BFB8.6010503@redhat.com>
	 <33307c790809181411j41a6fc4ev8560a13ed8661ec2@mail.gmail.com>
	 <48D2C46A.5030702@linux-foundation.org>
	 <33307c790809181421k52ed6a36h9d4ee40d5799a536@mail.gmail.com>
	 <48D2C8DD.4040303@linux-foundation.org>
	 <28c262360809181449v1050c1f7ndf17dadba9fac0bf@mail.gmail.com>
	 <48D2CEF3.6060308@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My patches were only for anonymous pages not for file backed because readahead
> is available for file backed mappings.

Do we populate the PTEs though? I didn't think that was batched, but I
might well be wrong.

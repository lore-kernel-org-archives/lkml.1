Return-Path: <linux-kernel-owner+w=401wt.eu-S936881AbXFGVLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936881AbXFGVLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760473AbXFGVLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:11:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:2447 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbXFGVLp (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C8BCVXwy6/JS67GXBJtTVbydYUHHqufaaXOtRtvi/bok7BmAZ4c3Kv+yOAYqJazoW8Naey8cz8UcKDXCies9nqE+V81tP5i6lziynnPMJsYafvfvxKQOn9pEPAEzIVO+KnnZism4ug94alOy7gZB3CxlPuTd3fQ2RxOsmTvziec=
Message-ID: <6934efce0706071411y6d184629i5ce0694175bef164@mail.gmail.com>
Date: Thu, 7 Jun 2007 14:11:44 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jared Hulbert" <jaredeh@gmail.com>, carsteno@de.ibm.com,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070607193707.GA17144@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4653F264.1030807@de.ibm.com>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org>
	 <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com>
	 <20070606161621.GA20247@infradead.org>
	 <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com>
	 <20070607193707.GA17144@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> that even more important doesn't require pulling in
> the whole block layer which is especially important for embedded
> devices at the lower end of the scala.

Good point.  That is a big oversight.  Though I would prefer to handle
that in the same fs rather than fork.

> I still think it'd be even better to just
> hook xip support into jffs or logfs because they give you a full
> featured flash filesystem for all needs without the complexity
> of strictly partitioning between xip-capable and write parts
> of your storage.

This is nirvana.   But it is not the goal of the patches in question.
In fact there are several use cases that don't need and don't value
the writeability and don't need therefore the overhead.  It is a long
term goal never the less.

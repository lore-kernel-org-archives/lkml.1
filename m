Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYHVSQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYHVSQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYHVSQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:16:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:5691 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYHVSQV (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:16:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pZprWEcA9ilGNmVzHMq+GoqEBJglEZMH3n4WaRzrPX4hjBAtH6V3peeBU2U7iez7rZ
         xkE+Ci5lp9Sqwy55eM1X9r5e3mAUg8g6TN0rJOLvSlD9YspVQkYme1l0KBdRfRQIwTFS
         THZwtLMYlWBI1vZ3ZwN6yr0KjGkBMMHudIlQw=
Message-ID: <6934efce0808221116w76a662b0t954b0922b69d3232@mail.gmail.com>
Date: Fri, 22 Aug 2008 11:16:20 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Jamie Lokier" <jamie@shareable.org>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: "Greg Ungerer" <gerg@snapgear.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <20080822181314.GB24179@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org>
	 <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com>
	 <48AE0476.80109@snapgear.com> <20080822181314.GB24179@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 11:13 AM, Jamie Lokier <jamie@shareable.org> wrote:
> Greg Ungerer wrote:
>> One thing for sure is that many people who do non-MMU setups
>> are interested in XIP to get the space savings. These are very
>> often small devices with very constrained RAM and flash. (For
>> whatever it is worth single NOR flash only boards are common in
>> these smaller form factors :-)
>
> I'm using XIP on a device with 32MB RAM.  The reason I use it is
> _partly_ to save RAM, partly because programs start about 10 times
> faster (reading NOR flash is slow and I keep the XIP region in RAM)

What kind of NOR you using?  That is not what I measure with fast
synchronous burst NOR's.

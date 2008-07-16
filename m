Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbYGPQON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbYGPQON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbYGPQN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:13:56 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:49283 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476AbYGPQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M9mzro9OFK8Zh/E9b2IdNfeTX6/WFrVWF+Vk2CrOVbLPWwsauI3i55MRsBhBCaa03A
         I1HRCx/QFbIyMEc3DRu2b4Jodfx40gis7LwBzPYitMgt3VvyJe0XtKGb56Hz8CzZqc0r
         /kPbJdxph7CtS1SIXJoLZRqnBAQoUt/DAWJn4=
Message-ID: <19f34abd0807160913y32b5989fpfa99ece1b63ecc22@mail.gmail.com>
Date: Wed, 16 Jul 2008 18:13:53 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: fix /proc/*/pagemap some more
Cc: "Eric Sesterhenn" <snakebyte@gmx.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, stable@kernel.org
In-Reply-To: <20080716155947.GA4809@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716152025.GA23096@alice>
	 <20080716153628.GA5795@martell.zuzino.mipt.ru>
	 <20080716155947.GA4809@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 5:59 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Wed, Jul 16, 2008 at 07:36:28PM +0400, Alexey Dobriyan wrote:
>> On Wed, Jul 16, 2008 at 05:20:25PM +0200, Eric Sesterhenn wrote:
>> > with current -git a "cat /proc/4260/pagemap"
>> > gives me the following oops:
>>
>> reproduced
>
> Oh, wow!
>
> [PATCH] proc: fix /proc/*/pagemap some more

This reproduced for me on plain v2.6.26 as well. I'm guessing this
should be Cc stable as soon as possible...!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

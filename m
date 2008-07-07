Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbYGGRBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbYGGRBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbYGGRBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:01:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:5310 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbYGGRBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nUReowV+HibpSSHu1YCJsO8YQNWCNxFy8TaVxEWgGXQGtgygdVvMxk2SimZl4OdEjm
         Iyl6aGTRTJPJlFXVcXlrEJlFMLIEQfO3CVk1rOqZzkwLhjTwQHNtWhkhCNHtUc/rJ3Ml
         gWhLUMiQ8kMZgYDl/V/kX7y4cov+0bdVTjIBI=
Message-ID: <48f7fe350807071001l36ab3ddfh10d35c3764215aff@mail.gmail.com>
Date: Mon, 7 Jul 2008 13:01:18 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Hugh Dickins" <hugh@veritas.com>,
       benh@kernel.crashing.org, "Zan Lynx" <zlynx@acm.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <48724676.6010704@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com>
	 <486E4FD8.4010102@acm.org>
	 <Pine.LNX.4.64.0807042112130.16912@blonde.site>
	 <200807071806.11630.nickpiggin@yahoo.com.au>
	 <487239BE.8070505@de.ibm.com>
	 <48f7fe350807070916v4b8292aerb0a6fd0f360c5b9b@mail.gmail.com>
	 <48724676.6010704@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well it was only the new xorg-server that caused the bug for me. I
can't reproduce it else where....

On Mon, Jul 7, 2008 at 12:38 PM, Carsten Otte <cotte@de.ibm.com> wrote:
> Ryan Hope wrote:
>>
>> Have you tried running Xorg 1.4.99.905?
>
> I guess you mean the xserver? See, we don't have PCI and thus don't have any
> graphics hardware - it's a server platform ;-).
>

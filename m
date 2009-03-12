Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZCLJAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZCLJAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZCLJAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:00:43 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:63671 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZCLJAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:00:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LKhlpBM0Ymp4ePKaaa4n3/0G5Qdtjt6XGOpbwbW+J/r+jzQRrjNPb4rVlLu+EUR+H2
         DilNWOi1SJBadmOQHGih7Eyq5XATWU6RwQoK69+QpNa3VlDdz7agLQNjfsCbD9k7Sty3
         /ArhQsjNzkmHiFQtppWfZP1fm5KTATs/+v7SI=
MIME-Version: 1.0
In-Reply-To: <200903121922.53529.nickpiggin@yahoo.com.au>
References: <m2hc2yulrw.fsf@gmail.com>
	 <200903031452.43086.nickpiggin@yahoo.com.au>
	 <38b2ab8a0903120105s59f21e0dv1dd67df41dcb2f9d@mail.gmail.com>
	 <200903121922.53529.nickpiggin@yahoo.com.au>
Date: Thu, 12 Mar 2009 10:00:38 +0100
Message-ID: <38b2ab8a0903120200h2f586c41s58d6a1520cba5ea8@mail.gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and 
	fs
From: Francis Moreau <francis.moro@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 9:22 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>
> Ignore details like crashes, direct IO and coherency between data mappings
> and buffercache where things get a bit hairy, and it's just a writeback
> cache. The last thing you write to some location will be what you get back
> if you read from that location -- regardless of whether it is dirty or clean
> or not present when you ask for it (and has to be read from disk).
>

Well yes but I was wondering in the special where the kernel crash or
the power supply is down how the kernel is minimizing the risk of file
system inconsistency. Hence my questions about metadata handling.

Thanks
-- 
Francis

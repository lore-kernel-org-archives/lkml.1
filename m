Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZIUSMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZIUSMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZIUSMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:12:36 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60769 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZIUSMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:12:35 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 14:12:35 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Y6W4gn4t4I8zz0EPz4KnqwO0Rsal9kCGUm8GHU2cJZGAeQfZQsnJr9BCqLaOA92yVC
         B37K2rtmkyroO28xrzBY5crB586KXNf0tmdd27YPbq4zZeAHFnABur0ERJfMjehKqux9
         FYlCGcfv9iZrYtj50a92TGCbf1vFTReGQcelM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie>
	 <20090921174656.GS12726@csn.ul.ie>
	 <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1>
Date: Mon, 21 Sep 2009 21:05:01 +0300
X-Google-Sender-Auth: 958e707bb2fbd3eb
Message-ID: <84144f020909211105p4772920at1a20d286710d19b8@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 8:54 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> Lets just keep SLQB back until the basic issues with memoryless nodes are
> resolved. There does not seem to be an easy way to deal with this. Some
> thought needs to go into how memoryless node handling relates to per cpu
> lists and locking. List handling issues need to be addressed before SLQB.
> can work reliably. The same issues can surface on x86 platforms with weird
> NUMA memory setups.
>
> Or just allow SLQB for !NUMA configurations and merge it now.

I'm holding on to it until the issues are resolved.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZBZCKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZBZCKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZBZCKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:10:38 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:23394 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZBZCKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:10:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cpM0C+ORbys3p8LTuWRg3cT2ttDTGAdFjq5HbaZtmKSOIAXxt/w66TXJaPuZfMQkTs
         Q3mHqEXZO8HgYWkgRStz61KkTRHm7AXWnDiLOd7EB3fPkEJxAzIciyMWNQjpcGDNlBHl
         FCQljXqXWHDqnqt3C4BKZICeVPyCZ7yowEq94=
Date: Thu, 26 Feb 2009 03:10:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
Message-ID: <20090226021031.GA7553@nowhere>
References: <20090225203007.582030664@goodmis.org> <20090225203427.382137706@goodmis.org> <49A5F81F.6060604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A5F81F.6060604@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 06:02:07PM -0800, H. Peter Anvin wrote:
> Steven Rostedt wrote:
>> This patch creates a copy_word_from_user function that can copy
>> a space delimited word from user space. This puts the code in
>> a new lib/uaccess.c file. This keeps the code in a single location
>> and may be optimized in the future.
>
> I have a bit of an issue with the naming... at least *I* read this as  
> copying a machine word, which made me wonder why you didn't just use  
> "get_user".  I would suggest copy_token_from_user or something like that.
>
> 	-hpa

That was the first impression I had too (the sense of a machine word).
But token seems to me imprecise as well, too much generic.

Well, since it is well commented, I guess it's not so much an issue...


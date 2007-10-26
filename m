Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbXJZOks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbXJZOks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbXJZOkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:40:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:57425 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbXJZOkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:40:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sikRcS3VWZnwjkhyWLkFxz3NiHK/9EEZX3m6E3sj4ozecrUedwKfFXMbKJAzYrV5gDkmWfxjd+M1JqMWiAVhnGOjPc3U4S97T6z6HHx26iYQA7Cg1xa+GZfxRl229wx4AhmC2++fK/iGG5GLjmgaNvWXPkqCeyKGHzz4wecyc3w=
Message-ID: <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
Date: Fri, 26 Oct 2007 16:40:38 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Is gcc thread-unsafe?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Linus Torvalds <> wrote:

> The gcc developers seem to have had a total disregard for what people
> want or need, and every time some code generation issue comes up, there's
> a lot of people on the list that do language-lawyering, rather than admit
> that there might be a problem.

Please make a proposal for how gcc should be modified instead of just
shooting on the gcc people -- the root cause here is the way the C/C++
memory model is defined. (Note: I'm not in any way involved in gcc
development.)

You can find my proposal to improve gcc here:
http://gcc.gnu.org/ml/gcc/2007-10/msg00465.html

Bart Van Assche.

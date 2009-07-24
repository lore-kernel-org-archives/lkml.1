Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZGXOxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZGXOxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZGXOxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:53:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:8708 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZGXOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kPSFkNg9B0sRO0g31GRw4rYW0Cnx420ATJay6UxI5A1Ym7vGP0gfKlGk32iARQV8eK
         oWOhcFqPDWeiczwWChLbESWgFvSLlQGRcZQg5PZXl5Z8ivbkrPX9qVCS/eSJytuFt47I
         scNTFDjvtKXsfMdVSIBqtAD6ZflIVbMj3T1CU=
MIME-Version: 1.0
In-Reply-To: <1248446909.6987.110.camel@twins>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
	 <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
	 <1248442415.6987.56.camel@twins>
	 <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>
	 <1248443656.6987.61.camel@twins>
	 <454c71700907240704o32dcdeb3v57845eb9472dd04c@mail.gmail.com>
	 <1248446909.6987.110.camel@twins>
Date: Fri, 24 Jul 2009 22:53:14 +0800
Message-ID: <454c71700907240753l65e83b19qe914f116edfb236@mail.gmail.com>
Subject: Re: report a bug about sched_rt
From: sen wang <wangsen.linux@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/24 Peter Zijlstra <peterz@infradead.org>:
> On Fri, 2009-07-24 at 22:04 +0800, sen wang wrote:
>
>> just one question:
>> if cpu is free and there is running state task, how you do?
>> schedule the task up? or schedule idle task up?
>
> Well, when an RT group is over the bandwidth limit I don't consider them
> runnable. Therefore, failing to find any other tasks, we run the idle
> task.
>

you  consider them runnable. but sorry, what you consider is wrong!

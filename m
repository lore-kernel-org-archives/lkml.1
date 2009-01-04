Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZADPyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZADPyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZADPyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:54:11 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:57959 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbZADPyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L9CGwZ80qMWpJTbkHHAn1UT3KJARy53Zx9mvfnu5DDSGnzo4HJqHR7AGa+54n4BJki
         vyAL1+9F5SSHVDKEWfL0e+hLtQ8Q8a6urTFbvXnunby+f0vx59X58O/iuZgusxcJGs2k
         Q3QDbgZsIsqYhYFR/rczMSmKzdEixYaBPNRB0=
Message-ID: <c62985530901040754m15ed74caib2665e00b5037707@mail.gmail.com>
Date: Sun, 4 Jan 2009 16:54:06 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] bootchart: improve output based on Dave Jones' feedback
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
In-Reply-To: <20090104074454.17c103f9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20090104071638.64be922a@infradead.org>
	 <c62985530901040736g5d9c1f20y248d6e6c635bede3@mail.gmail.com>
	 <20090104074454.17c103f9@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/4 Arjan van de Ven <arjan@infradead.org>:
> On Sun, 4 Jan 2009 16:36:18 +0100
> "Frédéric Weisbecker" <fweisbec@gmail.com> wrote:
>
>>
>> BTW, it looks like the async initcall feature has not been merged
>> upstream, even not in tip/master. Was it too
>> risky, not enough tested or something?
>
> Linus didn't quite like how it was done (to put it mildly).
>
> I've redone it this weekend (and am now cleaning the code up for
> posting later today hopefully)...

So I will wait for your patches :-)
Since you are involved again in fastboot, perhaps you will use the
boot tracer which now traces
the sched events. And I'm sure this sched tracing can be improved for
your needs or anything.
Don't hesitate to report any feedbacks.

Thanks.

> Linus was right (as usual); the new way is much better both in terms
> of code cleanness and in terms of faster boot.

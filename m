Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZIERoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZIERoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 13:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZIERoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 13:44:05 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:57708 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZIERoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 13:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=N6UslFOem4zhdEcQy0TPW27E0S6X9Cag4++WOpHxzZjsO5VO828RgpqL4qmWuQ3NAw
         46qDiP4YDe9DyD9CG8ayAHfsT927RlG9I/L8sYQqZoNalJOl1CygdQs8i7NkKT8fd0+S
         Fwt+A6C/CZVPCOkhPQae4GxlgG9qVhNrYfqkA=
MIME-Version: 1.0
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501F0F575@exchange.ZeugmaSystems.local>
References: <Acotv57vW6nkRxQOQLuBf8W5yfJIlwAAtMAw> <DDFD17CC94A9BD49A82147DDF7D545C501F0F575@exchange.ZeugmaSystems.local>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Sat, 5 Sep 2009 19:43:43 +0200
Message-ID: <193b0f820909051043w3cf7f9excc2771381555ccdc@mail.gmail.com>
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
To: Anirban Sinha <ASinha@zeugmasystems.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 5, 2009 at 02:55, Anirban Sinha<ASinha@zeugmasystems.com> wrote:
> Hi Ingo and rest:
>
> I have been playing around with the sched_rt_runtime_us cap that can be
> used to limit the amount of CPU time allocated towards scheduling rt
> group threads. I am using 2.6.26 with CONFIG_GROUP_SCHED disabled (we
> use only the root user in our embedded setup). I have no other CPU
> intensive workloads (RT or otherwise) running on my system. I have
> changed no other scheduling parameters from /proc.
>
> I have written a small test program that:

Would you mind sending the source of this test?

Lucas De Marchi

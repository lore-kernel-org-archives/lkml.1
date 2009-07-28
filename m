Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZG1Pfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZG1Pfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZG1Pfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:35:46 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:33284 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZG1Pfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=wjvepiAOJJsouAiKG5+P3J8BMqTiveZIW2vjBS5xziXhmsr9JPliiBX1LOWkE/xOgh
         eshMQZ39FfjzXisltxEaKbPZWr73nKFr87OeMYn7muHFiz61xDX1gP1pv4ObcNvmTCN7
         XbNWFlDZy5BE+3/ZHFz1sVVmwzxD2BgHZDykc=
MIME-Version: 1.0
In-Reply-To: <20090728141753.GI28349@ghostprotocols.net>
References: <20090728001041.GG28349@ghostprotocols.net> <2c0942db0907272058h3e1fc583w77925d0cc761c47f@mail.gmail.com> 
	<20090728141753.GI28349@ghostprotocols.net>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Tue, 28 Jul 2009 08:35:24 -0700
X-Google-Sender-Auth: 9ba285ca90fe1a6e
Message-ID: <2c0942db0907280835t62601e59ya65f1aa7cc00e05a@mail.gmail.com>
Subject: Re: [PATCH 1/1 tip] perf top: Move hard coded list to 
	/etc/perfconfig/symbols.skip
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 7:17 AM, Arnaldo Carvalho de
Melo<acme@redhat.com> wrote:
>> I like approaching things from the 'everything works even in a
>> broken/hasty installation' point of view, and it's paid off for me.
>> Sane defaults are a wonderfully useful thing.
>
> While in general we agree with you, in this case the only problem would
> be that we would see a few functions on idle systems, i.e. not something
> catastrophic.

This is userspace we're talking about here. Where's the harm in
getting things right by default?

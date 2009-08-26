Return-Path: <linux-kernel-owner+w=401wt.eu-S1751737AbZHZQQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbZHZQQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZHZQQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:16:13 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64530 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZHZQQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V9nlMT+RER3izMsTO1JbyDtsEXhayr3uJqVrBSseUMdY4w1PfUbrO7QfgcYi14E4vL
         BtAwre3bo08/Jp9PZxbnJd2cxGcatgGimoILh6mUi1GEUcYY5Xb/JyRYt67RvDdyCu7J
         4og9eUSSdGfFXuAtiKyrso2t90mZVWKpuiApQ=
MIME-Version: 1.0
In-Reply-To: <1251302598.18584.31.camel@twins>
References: <1250983671.5688.21.camel@raz> <4A943A00.9080609@nortel.com>
	 <1251264700.7538.1178.camel@twins> <1251282598.3514.20.camel@raz>
	 <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	 <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>
	 <1251300625.18584.18.camel@twins>
	 <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
	 <1251302598.18584.31.camel@twins>
Date: Wed, 26 Aug 2009 19:16:12 +0300
X-Google-Sender-Auth: 22284ade6b29f158
Message-ID: <84144f020908260916l34a21cai1abf7b2ca7ac93a3@mail.gmail.com>
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       raz ben yehuda <raziebe@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Aug 26, 2009 at 7:03 PM, Peter Zijlstra<peterz@infradead.org> wrote:
> There needs to be some communication between the isolated and non
> isolated part, otherwise what's the point. Even when you'd let it handle
> say a network device as pure firewall, you'd need to configure the
> thing, requiring interaction.

The use case Christoph described was an user-space number cruncher app
that does some network I/O over RDMA IIRC. AFAICT, if he could isolate
a physical CPU for the thing, there would be little or no
communication with the non-isolated part. Yes, the setup sounds weird
but it's a real workload although pretty damn specialized.

On Wed, Aug 26, 2009 at 7:03 PM, Peter Zijlstra<peterz@infradead.org> wrote:
>> > If you think the kernel is too fat and does superfluous things for your
>> > needs, help trim it.
>>
>> Mind boogling nonsense. Please stop fantasizing and trolling.
>
> Oh, to lay down the crack-pipe and sod off.

I guess I'll go for the magic mushrooms then.

                        Pekka

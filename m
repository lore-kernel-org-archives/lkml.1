Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbZFETeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbZFETeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZFETeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:34:37 -0400
Received: from mail-qy0-f177.google.com ([209.85.221.177]:53151 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZFETeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:34:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Db26UqbH3kqMx1W1OASjC3uolIoJkLwGh1kGeHWumwWkVw3XP6MmdETB0BV8JvAHAU
         5WH20WTpXzB3QxK5lPyEI+tYG0ER1pe0Th6Fb3/A/ejq8g2EKldq5JHOvPOa1AWjv/H/
         z+uX616bbKBK5+okmniQyq/4/04yaqmKs9iOw=
MIME-Version: 1.0
In-Reply-To: <20090605191851.393195588@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
	 <20090605191851.393195588@gentwo.org>
Date: Fri, 5 Jun 2009 12:34:37 -0700
X-Google-Sender-Auth: c8fdd91d6390a478
Message-ID: <e9c3a7c20906051234m499aefbrd1828a6bbee3caf9@mail.gmail.com>
Subject: Re: [this_cpu_xx 06/11] Eliminate get/put_cpu
From: Dan Williams <dan.j.williams@intel.com>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Eric Biederman <ebiederm@aristanetworks.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David L Stevens <dlstevens@us.ibm.com>, mingo@elte.hu,
       rusty@rustcorp.com.au, davem@davemloft.net,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added Maciej to the cc ]

On Fri, Jun 5, 2009 at 12:18 PM, <cl@linux-foundation.org> wrote:
> There are cases where we can use this_cpu_ptr and as the result
> of using this_cpu_ptr() we no longer need to determine the
> current executing cpu.
>
> In those places no get/put_cpu combination is needed anymore.
> The local cpu variable can be eliminated.
>
> Preemption still needs to be disabled and enabled since the
> modifications of the per cpu variables is not atomic. There may
> be multiple per cpu variables modified and those must all
> be from the same processor.
>
> cc: Dan Williams <dan.j.williams@intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>

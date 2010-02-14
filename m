Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab0BNOGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 09:06:50 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:50361 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab0BNOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 09:06:48 -0500
MIME-Version: 1.0
In-Reply-To: <1266127834.16346.60.camel@pasglop>
References: <20100213154838.4767.83881.stgit@angua> <20100213160242.4767.57641.stgit@angua> 
	<1266127834.16346.60.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 14 Feb 2010 07:06:28 -0700
X-Google-Sender-Auth: 39e422b10eec3ba8
Message-ID: <fa686aa41002140606s798f356ft6dcea472f7076bdd@mail.gmail.com>
Subject: Re: [PATCH 3/9] of: protect linux/of.h with CONFIG_OF
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: monstr@monstr.eu, sfr@canb.auug.org.au, jeremy.kerr@canonical.com,
       davem@davemloft.net, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 11:10 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Sat, 2010-02-13 at 09:02 -0700, Grant Likely wrote:
>> From: Jeremy Kerr <jeremy.kerr@canonical.com>
>>
>> For platforms that have CONFIG_OF optional, we need to make the contents
>> of linux/of.h conditional on CONFIG_OF.
>>
>> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>
> For now...
>
> In the long run, maybe we want some of the iterators to be empty inlines
> returning NULL ?

Yes.  I'll add them as they are needed.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbZFLCK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbZFLCK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 22:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbZFLCKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 22:10:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:40540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbZFLCKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 22:10:18 -0400
Message-ID: <4A31B8BF.30304@kernel.org>
Date: Fri, 12 Jun 2009 11:09:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [this_cpu_xx 01/11] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
References: <20090605191819.376530498@gentwo.org> <20090605191850.441840884@gentwo.org> <4A2F40A3.5020602@kernel.org> <alpine.DEB.1.10.0906111109410.29827@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0906111109410.29827@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 02:09:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 10 Jun 2009, Tejun Heo wrote:
> 
>> Looks good to me.  The only qualm I have is that I wish these macros
>> take pointer instead of the symbol name directly.  Currently it's not
> 
> They take the adress of the scalar. No symbol name is involved.
> 
>> possible due to the per_cpu__ appending thing but those should go with
>> Rusty's patches and the same ops should be useable for both static and
>> dynamic ones.  One problem which may occur with such scheme is when
> 
> They are usable for both as the following patches show.

Oops, sorry about that.  Got confused there.  :-)

Thanks.

-- 
tejun

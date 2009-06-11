Return-Path: <linux-kernel-owner+w=401wt.eu-S1763716AbZFKPLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763716AbZFKPLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZFKPKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:10:55 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:49648 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751505AbZFKPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:10:54 -0400
Date: Thu, 11 Jun 2009 11:10:32 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [this_cpu_xx 01/11] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
In-Reply-To: <4A2F40A3.5020602@kernel.org>
Message-ID: <alpine.DEB.1.10.0906111109410.29827@gentwo.org>
References: <20090605191819.376530498@gentwo.org> <20090605191850.441840884@gentwo.org> <4A2F40A3.5020602@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009, Tejun Heo wrote:

> Looks good to me.  The only qualm I have is that I wish these macros
> take pointer instead of the symbol name directly.  Currently it's not

They take the adress of the scalar. No symbol name is involved.

> possible due to the per_cpu__ appending thing but those should go with
> Rusty's patches and the same ops should be useable for both static and
> dynamic ones.  One problem which may occur with such scheme is when

They are usable for both as the following patches show.

Return-Path: <linux-kernel-owner+w=401wt.eu-S965773AbXCPReZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965773AbXCPReZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965774AbXCPReZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:34:25 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:58190 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965773AbXCPReY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:34:24 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: + getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch added to -mm tree
Date: Fri, 16 Mar 2007 18:34:23 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070316171023.GA218@tv-sign.ru> <200703161823.57858.dada1@cosmosbay.com>
In-Reply-To: <200703161823.57858.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161834.23901.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 18:23, Eric Dumazet wrote:

>
> Very good point, you found a bug in k_getrusage().
>
> I just followed the existing logic, but it seems this logic is bad.
>
> So not only ru_inblock/ru_oublock are multiplied by 3 : others fields as
> well are wrong.
>
> Also the definition of RUSAGE_CHILDREN is not conformant to standard
>
> http://www.opengroup.org/onlinepubs/009695399/functions/getrusage.html
>
> 	"If the value of the who argument is RUSAGE_CHILDREN, information shall be
> 	"returned about resources used by the terminated and waited-for children
> of "the current process
>
> We currently do a sum of rusage stats of still alive children.. thats
> totally wrong...

Please ignore this mail, I was very wrong.

I shall rethink a proper patch.

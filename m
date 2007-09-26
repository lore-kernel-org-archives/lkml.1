Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbXIZQwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbXIZQwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759721AbXIZQwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:52:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:48997 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532AbXIZQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a04ufx0+PS7Qk86BChpWS+R+tUfEy0r60NPfuGGVlUUgF1EHrXwasdOgypjRY0puPwp4n8K/cHlODjJ6mCF6WgvFyIIthQFHMF3zzZI9UZtNWzbvMP5PO2EJ17aPEWVx1H8OX/5z0GIf5VccqU7uPPhxWUY1aanWG/IUABTXKy4=
Message-ID: <863e9df20709260952p3cc99b02n15e411a9b29b9fd4@mail.gmail.com>
Date: Wed, 26 Sep 2007 22:22:04 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: ananth@in.ibm.com
Subject: Re: KPROBES: Instrumenting a function's call site
Cc: "Avishay Traeger" <atraeger@cs.sunysb.edu>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070926043933.GA6460@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu>
	 <20070926043933.GA6460@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/07, Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> PS: There was a thought of providing a facility to run a handler at
> function entry even when just a kretprobe is used. Maybe we need to
> relook at that; it'd have been useful in this case.

That would be really useful. I was writing a tool to dump some
function profiling info through /proc. This would help save an extra
probe on each function's entry.

-
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

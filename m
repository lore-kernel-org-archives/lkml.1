Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbXIYF1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbXIYF1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 01:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbXIYF1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 01:27:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:50817 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbXIYF1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 01:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H4MStYgFAl+OgIDCa0Hp+MFrbHaiIkw8l6GHctU/1Ok7TavmHcA+pjXFj88k7p7BgVJCwESrrWIAh7AFNnWMVMWJGFyEJZulodkTqNfYiCbJ2o4VWNLMYCi3qdnn3+sStqXcXFf02l7EqWQSQfpD4gvU/l1E/1LbvlBq2dXq95M=
Message-ID: <19f34abd0709242227n5ac1f7dp5b1589ceeb3e4c0e@mail.gmail.com>
Date: Tue, 25 Sep 2007 07:27:33 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Miguel Ojeda" <maxextreme@gmail.com>
Subject: Re: [RFC] New kernel-message logging API
Cc: LKML <linux-kernel@vger.kernel.org>, holzheu <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>
In-Reply-To: <653402b90709221805pd1b7efel165a1c55100e3610@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <653402b90709221805pd1b7efel165a1c55100e3610@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/07, Miguel Ojeda <maxextreme@gmail.com> wrote:
> Nice. I would suggest having some kind of standard way to show the
> information on the screen/dmesg. I mean, instead of having plain lines
> being written to the log, having something very short like:

Thanks for the idea. Is this something you want to (manually) insert
in each printk, or would it be passed like a parameter? For the
subsystem part, it might be possible to #define a subsystem name at
the beginning of each file and have printing functions automatically
use this. But otherwise, I think the usefulness of this is perhaps a
little low compared to the effort needed (ie. for this to be useful,
each and every printk of the kernel would need to be changed). Also
notice, even in your examples, that most subsystems/drivers already
prefix their messages to identify the source. Perhaps a better effort
spent would be to go through the ones that are missing this "source"
prefix and fix them?

Vegard

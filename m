Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYIMFLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYIMFLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 01:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYIMFLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 01:11:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:21121 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYIMFLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 01:11:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FWmfPrMRn+kp9D6H/5qDtQ3uPShzYqoyB8JnPEsOd2ygSDMYWNjkxOWjFcSewEcMDr
         CbvY+KU5Bmxb7EJN7RyXBbOiLyINhY/z1VBFwcHxzTwkCnpRyLJ0UlohTv+MYQPFhzQa
         ZMlBJ3QMgv9YFyQV6i8BInekYmDjYl2Xvvm0A=
Date: Sat, 13 Sep 2008 09:12:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jeffrey Brian Arnold <jbarnold@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [RFC PATCH 0/9] Ksplice: Rebootless kernel updates
Message-ID: <20080913051252.GA6306@x200.localdomain>
References: <1221281397-7045-1-git-send-email-jbarnold@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221281397-7045-1-git-send-email-jbarnold@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 12:49:46AM -0400, Jeffrey Brian Arnold wrote:
> These RFC patches add support for Ksplice [1], a rebootless update system, 
> to the kernel.

> The basic idea is that Ksplice can apply an update to a running 
> Linux kernel based only on a source code patch and the original kernel 
> source.

Please, taint kernel after first update so some of us can ignore oopses
of hopelessly broken kernels.

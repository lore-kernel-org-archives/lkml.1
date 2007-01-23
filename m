Return-Path: <linux-kernel-owner+w=401wt.eu-S932963AbXAWK7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbXAWK7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 05:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932964AbXAWK7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 05:59:52 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:53707 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963AbXAWK7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 05:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y+VonFAoazXQIxs97l0mcd92oqEradjrtiBoU8BG7b7EiVwBjS+IxV67GU5+GT8XK91tXX29jrdKbii5foaSY2RBq0CodI+afbMa8nFwYAEVq+ndqRSKVg/5Lr50OEF6gBwGxaxtpJIUETFsy7K3SdqB5EPCT224+0EHGbrfu38=
Message-ID: <9e0cf0bf0701230259j66fff95fw9b3e373a1997c843@mail.gmail.com>
Date: Tue, 23 Jan 2007 12:59:50 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>,
       "Tomas Carnecky" <tom@dbservice.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
In-Reply-To: <20070123105331.GB20660@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070118125849.441998000@strauss.suse.de>
	 <20070118141359.GB31418@flint.arm.linux.org.uk>
	 <45AF92E7.50901@dbservice.com>
	 <20070118152326.GC31418@flint.arm.linux.org.uk>
	 <20070122221400.GE6262@strauss.suse.de>
	 <20070122222725.GB32085@flint.arm.linux.org.uk>
	 <9e0cf0bf0701230237j5aa1bbya3a70da314e471b9@mail.gmail.com>
	 <20070123104140.GA20660@flint.arm.linux.org.uk>
	 <9e0cf0bf0701230250nb8d9738redc3e1d963b40bda@mail.gmail.com>
	 <20070123105331.GB20660@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> Why do you want to remove the static?

Since current design declare a buffer in main.c which is used by arch
specific startup code, mainly setup.c.

Regards,
Alon Bar-Lev.

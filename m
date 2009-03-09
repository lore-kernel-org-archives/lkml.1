Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZCIKy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZCIKy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 06:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZCIKys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 06:54:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:10874 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZCIKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 06:54:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y2wierq/5NOwErpaRbjPu52WiUCZ0UbPbsiXf4cdzRMIGINgb/HkY2NLsMnSNsK9Bo
         GXWQ7nCJzUAwtWBd+a3xAeAjLqCLGOiwvKG73D0z0SovUNEutbpL2tSKrq+mA8R47F8e
         KNs27OdGAIhRxbcb6b4ArVrrV5SWXjJPYlIl8=
Subject: Re: Acer Aspire One fan control
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <cone.1234473266.28534.5384.1000@mentalhome>
References: <cone.1234471033.988571.5384.1000@mentalhome>
	 <20090212210330.GH12846@charite.de>
	 <cone.1234473266.28534.5384.1000@mentalhome>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 12:54:41 +0200
Message-Id: <1236596081.609.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 22:14 +0100, Peter Feuerer wrote:
> Ralf Hildebrandt writes:
> 
> > There's a userspace program for that. So why add a kernel module?
> 
> Because you must write to and read from io-ports and I think this should be 
> done in the kernel. I guess the userspace program you are talking about is 
> acer_ec.pl? A perl script which needs very much cpu time for a 
> functionality which can be handled in kernelspace without causing any big 
> troubles.
Not just that.
While on acer one it seems that if I kill userspace script,
fan restores to its original state (eg: running), I would also
like such driver on my main notebook, which is also acer.
It fan is also controlled via EC, but 'control' is done via hack
in acpi thermal code, every time it is updated, it sends new temperature
to EC, so I can just unload acpi thermal driver, and use own
script/driver do do same job, but I afraid that usespace driver can
hung/be killed/etc leaving me without fan at all, so this why kernel
driver is better - it is more reliable.

Best regards,
	Maxim Levitsky



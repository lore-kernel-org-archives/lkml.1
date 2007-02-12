Return-Path: <linux-kernel-owner+w=401wt.eu-S965342AbXBLTpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965342AbXBLTpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXBLTpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:45:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:47107 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965342AbXBLTpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:45:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KKe+qpY40baeSkyuvC1sXMTTbRcyglUQdO7k/89uAgjjDFx6/zn7e76euF/b4wB8K0dS/4LjKAeViozMB5GyrxBycIqF37fqiStohL2qEoAdH0QwbWIu+NmbX4PQ7ewkfNF1kSs3ySNcgrXoLBag61X9eYknd5cEPQI7XEWbZfg=
Subject: Re: [PATCH x86 for review II] [34/39] i386: Use stack arguments
	for calling into EFI
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= RISS <frederic.riss@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070212073822.8F33E13D7F@wotan.suse.de>
References: <20070212837.963446000@suse.de>
	 <20070212073822.8F33E13D7F@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 12 Feb 2007 20:45:26 +0100
Message-Id: <1171309527.28934.28.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 février 2007 à 08:38 +0100, Andi Kleen a écrit :
> When calling into the EFI firmware, the parameters need to be passed on
> the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
> This patch is needed to allow the new Intel-based Macs to suspend to ram
> (efi.get_time is called during the suspend phase).
> 
> Signed-off-by: Frederic Riss <frederic.riss@gmail.com>
> Signed-off-by: Andi Kleen <ak@suse.de>

For 2.6.20, Linus merged a different version touching only
arch/kernel/efi.c. If you really prefer this version, I guess it should
be discussed more thoroughly with him and the EFI guys. 

Fred.


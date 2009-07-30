Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZG3WQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZG3WQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZG3WQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:16:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58145 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZG3WQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:16:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tODPtBeobzXbcdZZ1gaQyXnk44Fxte6bHX9L967+M0+Vun5hjHsTttF0h6BH68CZU
	dDFFkw09OD+TdJmTqPbXA==
Date: Thu, 30 Jul 2009 15:16:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kurt Roeckx <kurt@roeckx.be>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #13780] NULL pointer dereference loading powernowk8
In-Reply-To: <H5-1lZIIeYK.A.qoF.sWObKB@chimera>
Message-ID: <alpine.DEB.2.00.0907301514510.18807@chino.kir.corp.google.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.qoF.sWObKB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13780
> Subject		: NULL pointer dereference loading powernowk8
> Submitter	: Kurt Roeckx <kurt@roeckx.be>
> Date		: 2009-07-15 18:00 (12 days old)
> 

powernowk8_cpu_init() has since been largely modified for cpumask changes 
commit 1ff6e97f1d993dff2f9b6f4a9173687370660232.  

Kurt, could you try 2.6.31-rc4?  If it still hits a bug, please post the 
dmesg and your .config.

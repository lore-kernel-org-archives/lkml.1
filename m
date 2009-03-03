Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbZCCVzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbZCCVzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZCCVzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:55:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14885 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbZCCVzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:55:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=OFLivunnYZnA4WCDDn/33q0uX8POSdpXYr8oA6hFQ5lZp5uyJ/1lCPRvjXxdXjGm9
	S+vTsi4DBAJzSZFhZ7NGQ==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0903031330090.23523@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903031136380.26454@qirst.com>
	 <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903031345150.9466@qirst.com>
	 <alpine.DEB.2.00.0903031057110.15900@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903031509380.25612@qirst.com>
	 <alpine.DEB.2.00.0903031330090.23523@chino.kir.corp.google.com>
Date: Tue, 3 Mar 2009 13:55:38 -0800
Message-ID: <6599ad830903031355y3e12dec6n4b7b675d354f8e72@mail.gmail.com>
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 1:35 PM, David Rientjes <rientjes@google.com> wrote:
>
> Unfortunately, we can't add a slab hardwall flag to the cpuset to
> configure this behavior since that would require locking to dereference
> in the fastpath.
>

I don't think that it would - cgroups and subsystems should be RCU safe.

Paul

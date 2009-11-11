Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZKKN0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZKKN0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 08:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbZKKN0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 08:26:24 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52693 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZKKN0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 08:26:23 -0500
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to
 the balloon driver
From: Adam Litke <agl@us.ibm.com>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Jamie Lokier <jamie@shareable.org>, Anthony Liguori <aliguori@us.ibm.com>,
       agl@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
       Avi Kivity <avi@redhat.com>
In-Reply-To: <20091111101223.GA22937@redhat.com>
References: <1257782838.2835.5.camel@aglitke>
	 <1257784326.2835.16.camel@aglitke>
	 <200911101312.02650.rusty@rustcorp.com.au> <4AF97A5E.1070801@codemonkey.ws>
	 <4AF97C1A.2080609@redhat.com> <4AF97F93.2080707@us.ibm.com>
	 <20091111092409.GA24646@shareable.org>  <20091111101223.GA22937@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 11 Nov 2009 07:26:24 -0600
Message-ID: <1257945984.2876.1.camel@aglitke>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 10:12 +0000, Daniel P. Berrange wrote:
> This all suggests that we should only update the stats from the guest
> when something on the host actually asks for them by issuing the QEMU
> monitor command. We don't want any kind of continuous polling of stats
> at any frequency, if nothing is using these stats on the host.

Agreed.  The next version of the patch will remove the timer completely.
We'll wake up in response to config change notifications only.

-- 
Thanks,
Adam


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZFDSYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZFDSYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZFDSYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:24:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55436 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZFDSYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:24:19 -0400
Message-ID: <4A28111A.3080000@redhat.com>
Date: Thu, 04 Jun 2009 21:23:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       anthony@codemonkey.ws, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org, bhutchings@solarflare.com, andi@firstfloor.org,
       gregkh@suse.de, herber@gondor.apana.org.au, chrisw@sous-sol.org,
       shemminger@vyatta.com
Subject: Re: [RFC PATCH v2 03/19] vbus: add connection-client helper	infrastructure
References: <20090409155200.32740.19358.stgit@dev.haskins.net> <20090409163057.32740.27829.stgit@dev.haskins.net> <20090604180611.GA16387@redhat.com>
In-Reply-To: <20090604180611.GA16387@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> Also - if we just had vmexit because a process executed
> io (or hypercall), can't we just do copy_to_user there?
> Avi, I think at some point you said that we can?
>   

You can do copy_to_user() whereever it is legal in Linux.  Almost all of 
kvm runs in process context, preemptible, and with interrupts enabled.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


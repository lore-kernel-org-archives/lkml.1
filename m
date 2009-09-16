Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbZIPUZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbZIPUZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759967AbZIPUZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:25:29 -0400
Received: from claw.goop.org ([74.207.240.146]:41506 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759965AbZIPUZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:25:27 -0400
Message-ID: <4AB149BA.1000106@goop.org>
Date: Wed, 16 Sep 2009 13:25:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eddie Dong <eddie.dong@intel.com>, linux-kernel@vger.kernel.org,
       Jun Nakajima <jun.nakajima@intel.com>
Subject: Re: [Xen-devel] [RFC][PATCH 07/10] xen/hybrid: Add PV timer support
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com> <1253090551-7969-8-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1253090551-7969-8-git-send-email-sheng@linux.intel.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/09 01:42, Sheng Yang wrote:
> If we have event channel, we can use VIRQ_TIMER to deliver timer interrupt,
> otherwise we would reuse IRQ0.
>   

What's the purpose of this?  Why can we get a timer virq via event
channel as usual?  I'm very dubious about having any platform
interrupts/apic interaction in this code.

    J

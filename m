Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbXJJRtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbXJJRtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 13:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXJJRtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 13:49:42 -0400
Received: from gw.goop.org ([64.81.55.164]:33319 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbXJJRtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 13:49:41 -0400
Message-ID: <470D1088.1030908@goop.org>
Date: Wed, 10 Oct 2007 10:48:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH RFC REPOST 1/2] paravirt: refactor struct paravirt_ops
 into smaller pv_*_ops
References: <470BC758.1030504@goop.org> <200710101635.10139.rusty@rustcorp.com.au>
In-Reply-To: <200710101635.10139.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> +	OFFSET(PARAVIRT_enabled, pv_info, paravirt_enabled);
>>     
>
> I think this gives the right answer for the wrong reasons?
>   

Actually, it was OK.  The only use is in entry.S, which uses pv_info +
PARAVIRT_enabled.

    J

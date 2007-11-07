Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbXKGFzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbXKGFzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXKGFzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:55:43 -0500
Received: from il.qumranet.com ([82.166.9.18]:43459 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbXKGFzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:55:43 -0500
Message-ID: <4731535E.5000808@qumranet.com>
Date: Wed, 07 Nov 2007 07:55:42 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       kvm-devel@lists.sourceforge.net, jeremy@goop.org,
       linux-kernel@vger.kernel.org, hollisb@us.ibm.com
Subject: Re: [kvm-devel] include files for kvmclock
References: <11943875362987-git-send-email-gcosta@redhat.com>	<11943875433821-git-send-email-gcosta@redhat.com> <5d6222a80711061335q7ef03b42i335bb1e8c07eb7e4@mail.gmail.com>
In-Reply-To: <5d6222a80711061335q7ef03b42i335bb1e8c07eb7e4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 07 Nov 2007 07:55:42 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
>> +union kvm_hv_clock {
>> +       struct {
>> +               u64 tsc_mult;
>> +               u64 now_ns;
>> +               /* That's the wall clock, not the water closet */
>> +               u64 wc_sec;
>> +               u64 wc_nsec;
>>     

Do we really need 128-bit time?  you must be planning to live forever.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


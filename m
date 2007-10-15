Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbXJOTYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbXJOTYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbXJOTX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:23:57 -0400
Received: from gw.goop.org ([64.81.55.164]:48034 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbXJOTX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:23:57 -0400
Message-ID: <4713BE43.50506@goop.org>
Date: Mon, 15 Oct 2007 12:23:47 -0700
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
References: <470BC758.1030504@goop.org> <200710120001.52456.rusty@rustcorp.com.au> <470FC7F4.1030300@goop.org> <200710151816.36758.rusty@rustcorp.com.au>
In-Reply-To: <200710151816.36758.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 13 October 2007 05:16:04 Jeremy Fitzhardinge wrote:
>   
>> Are you otherwise happy with the patch in its current form?  And are you
>> happy with the lazymode changes?
>>     
>
> No, and yes.
>
> This applies on top of your 1/2.  Boots here, runs lguest.  It also 
> exports pv_info: lg.ko checks it to avoid lguest-in-lguest.
>   

Yeah, OK, I can live with that.  I'll fold it into the base patch, and
update the lazymode patch accordingly.

    J

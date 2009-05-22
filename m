Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZEVE3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZEVE3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZEVE25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:28:57 -0400
Received: from claw.goop.org ([74.207.240.146]:46234 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZEVE1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:27:37 -0400
Message-ID: <4A1629BA.9070309@goop.org>
Date: Thu, 21 May 2009 21:27:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
CC: Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Li, Xin" <xin.li@intel.com>, "Nakajima, Jun" <jun.nakajima@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org> <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com> <4A15DA4E.2090505@goop.org> <C85CEDA13AB1CF4D9D597824A86D2B9005760A96DA@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <C85CEDA13AB1CF4D9D597824A86D2B9005760A96DA@PDSMSX501.ccr.corp.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xin, Xiaohui wrote:
> Remember we have done one experiment with "jump", the result shows seems the overhead is even more than the call.
>   

I don't think you had mentioned that. You're saying that a
call->jmp->ret is slower than call->call->ret->ret?

J

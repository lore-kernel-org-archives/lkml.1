Return-Path: <linux-kernel-owner+w=401wt.eu-S964845AbXBPNxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845AbXBPNxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964834AbXBPNxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:53:31 -0500
Received: from ns2.suse.de ([195.135.220.15]:48957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964845AbXBPNxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:53:31 -0500
Message-ID: <45D5B74A.6060905@suse.de>
Date: Fri, 16 Feb 2007 14:53:14 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Zachary Amsden <zach@vmware.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       xen-devel@lists.xensource.com, Ian Pratt <ian.pratt@xensource.com>,
       Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config options
 and disable unsupported config options.
References: <20070216022449.739760547@goop.org>	<20070216022531.570154735@goop.org> <45D54BFF.80100@vmware.com> <m11wkqimjd.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m11wkqimjd.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Have machine_kexec_prepare fail.
> 
> I think your machine description or paravirt_ops or whatever it is needs
> to hook both machine_kexec_prepare and machine_kexec.
> 
> I know there actually has been some work to get kexec actually working under
> Xen but I don't know where that has gone.

Works, modulo bugs.  Shouldn't be hard to get work on top of
paravirt_ops.  The current 2.6.18 code uses function pointers already
because the dom0 code looks very different from domU code.  It is one of
the items on my todo list.  I'll probably look into it once I'm done
with the earlyprintk and console mess ...

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZAOQwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZAOQwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZAOQwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:52:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57160 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbZAOQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:52:46 -0500
Message-ID: <496F69C8.2040103@zytor.com>
Date: Thu, 15 Jan 2009 08:52:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "harvey.harrison@gmail.com" <harvey.harrison@gmail.com>,
       "sam@ravnborg.org" <sam@ravnborg.org>,
       "jaswinderrajput@gmail.com" <jaswinderrajput@gmail.com>
Subject: Re: [patch 3/5] x86: headers cleanup - ptrace-abi.h
References: <20090114203745.285473388@gmail.com>> <496e4e23.0c07560a.5e4e.529c@mx.google.com> <496E6585.8050505@zytor.com> <928CFBE8E7CB0040959E56B4EA41A77E0CD9CD33@irsmsx504.ger.corp.intel.com> <20090115084110.GB9032@localhost>
In-Reply-To: <20090115084110.GB9032@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Hi Markus,
> 
> since it's supposed to be visible by userspace then we
> should just remove this CONFIG_X86_PTRACE_BTS so if userspace
> app has a reference to ptrace_bts_config but kernel in turn has
> this feature turned off -- the uerspace app shouldn't fail
> while being compiling.
> 

Well, for userspace, the kernel configuration doesn't matter: the
CONFIG_* macros *never* exist.

This would be yet another good reason why having them be always defined
and 0/1 instead would be such an improvement, but we're not there.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


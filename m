Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZKZBmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZKZBmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 20:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZKZBmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 20:42:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:34952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbZKZBmD (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 20:42:03 -0500
Message-ID: <4B0DDCDC.30305@kernel.org>
Date: Thu, 26 Nov 2009 10:41:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Theurer <habanero@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       Linux-kernel@vger.kernel.org
Subject: Re: kernel bug in kvm_intel
References: <4ACF9745.3050902@linux.vnet.ibm.com> <4AD16ACE.6040903@redhat.com> <1255372957.4883.49.camel@twinturbo.austin.ibm.com> <4AD4231F.6040608@redhat.com> <1255442640.4883.56.camel@twinturbo.austin.ibm.com> <4AD6061D.5070306@redhat.com> <1255637909.4883.129.camel@twinturbo.austin.ibm.com> <1256926052.4883.203.camel@twinturbo.austin.ibm.com> <4AEC5C24.9080506@redhat.com> <4AEC64FC.7070908@linux.vnet.ibm.com> <4AEC6699.6000202@redhat.com> <4AEC6821.7010801@redhat.com> <4AED5C3F.9050506@kernel.org> <4AED6100.6040804@redhat.com> <4AED66D0.20704@kernel.org> <4AED7178.2060906@redhat.com> <4B03BDCC.4080502@kernel.org> <4B0DDB5D.9030202@linux.vnet.ibm.com>
In-Reply-To: <4B0DDB5D.9030202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/26/2009 10:35 AM, Andrew Theurer wrote:
> I just tried testing tip of kvm.git, but unfortunately I think I might
> be hitting a different problem, where processes run 100% in kernel mode.
> In my case, cpus 9 and 13 were stuck, running qemu processes.  A stack
> backtrace for both cpus are below.  FWIW, kernel.org 2.6.32-rc7 does not
> have this problem, or the original problem.

2.6.32-rc7 doesn't have problem with kvm + oprofile?  If the original
analysis was right, I can't think of anything which could have changed
that between the merge commit and 2.6.32-rc7.

Thanks.

-- 
tejun

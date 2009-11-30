Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZK3Q2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZK3Q2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZK3Q17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:27:59 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56982 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbZK3Q16 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:27:58 -0500
Subject: Re: kernel bug in kvm_intel
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Avi Kivity <avi@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, kvm@vger.kernel.org,
       Linux-kernel@vger.kernel.org
In-Reply-To: <4B12895A.2010706@redhat.com>
References: <4ACF9745.3050902@linux.vnet.ibm.com>
	 <4AD16ACE.6040903@redhat.com>
	 <1255372957.4883.49.camel@twinturbo.austin.ibm.com>
	 <4AD4231F.6040608@redhat.com>
	 <1255442640.4883.56.camel@twinturbo.austin.ibm.com>
	 <4AD6061D.5070306@redhat.com>
	 <1255637909.4883.129.camel@twinturbo.austin.ibm.com>
	 <1256926052.4883.203.camel@twinturbo.austin.ibm.com>
	 <4AEC5C24.9080506@redhat.com> <4AEC64FC.7070908@linux.vnet.ibm.com>
	 <4AEC6699.6000202@redhat.com> <4AEC6821.7010801@redhat.com>
	 <4AED5C3F.9050506@kernel.org> <4AED6100.6040804@redhat.com>
	 <4AED66D0.20704@kernel.org> <4AED7178.2060906@redhat.com>
	 <4B03BDCC.4080502@kernel.org> <4B0DDB5D.9030202@linux.vnet.ibm.com>
	 <4B12895A.2010706@redhat.com>
Content-Type: text/plain
Date: Mon, 30 Nov 2009 10:27:44 -0600
Message-Id: <1259598464.29314.2.camel@twinturbo.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-29 at 16:46 +0200, Avi Kivity wrote:
> On 11/26/2009 03:35 AM, Andrew Theurer wrote:
> > I just tried testing tip of kvm.git, but unfortunately I think I might 
> > be hitting a different problem, where processes run 100% in kernel 
> > mode.  In my case, cpus 9 and 13 were stuck, running qemu processes.  
> > A stack backtrace for both cpus are below.  FWIW, kernel.org 
> > 2.6.32-rc7 does not have this problem, or the original problem.
> 
> I just posted a patch fixing this, titled "[PATCH tip:x86/entry] core: 
> fix user return notifier on fork()".
> 
Thank you, Avi.  I am running on this patch and am not seeing this
problem anymore.  I'll be testing for the previous issue next.

-Andrew


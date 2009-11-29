Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZK2Ore@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZK2Ore (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 09:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZK2Ord
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 09:47:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbZK2Ord (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 09:47:33 -0500
Message-ID: <4B12895A.2010706@redhat.com>
Date: Sun, 29 Nov 2009 16:46:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Theurer <habanero@linux.vnet.ibm.com>
CC: Tejun Heo <tj@kernel.org>, kvm@vger.kernel.org,
       Linux-kernel@vger.kernel.org
Subject: Re: kernel bug in kvm_intel
References: <4ACF9745.3050902@linux.vnet.ibm.com> <4AD16ACE.6040903@redhat.com> <1255372957.4883.49.camel@twinturbo.austin.ibm.com> <4AD4231F.6040608@redhat.com> <1255442640.4883.56.camel@twinturbo.austin.ibm.com> <4AD6061D.5070306@redhat.com> <1255637909.4883.129.camel@twinturbo.austin.ibm.com> <1256926052.4883.203.camel@twinturbo.austin.ibm.com> <4AEC5C24.9080506@redhat.com> <4AEC64FC.7070908@linux.vnet.ibm.com> <4AEC6699.6000202@redhat.com> <4AEC6821.7010801@redhat.com> <4AED5C3F.9050506@kernel.org> <4AED6100.6040804@redhat.com> <4AED66D0.20704@kernel.org> <4AED7178.2060906@redhat.com> <4B03BDCC.4080502@kernel.org> <4B0DDB5D.9030202@linux.vnet.ibm.com>
In-Reply-To: <4B0DDB5D.9030202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2009 03:35 AM, Andrew Theurer wrote:
> I just tried testing tip of kvm.git, but unfortunately I think I might 
> be hitting a different problem, where processes run 100% in kernel 
> mode.  In my case, cpus 9 and 13 were stuck, running qemu processes.  
> A stack backtrace for both cpus are below.  FWIW, kernel.org 
> 2.6.32-rc7 does not have this problem, or the original problem.

I just posted a patch fixing this, titled "[PATCH tip:x86/entry] core: 
fix user return notifier on fork()".

-- 
error compiling committee.c: too many arguments to function


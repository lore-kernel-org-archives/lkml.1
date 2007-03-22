Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXCVOtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXCVOtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933041AbXCVOtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:49:31 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52086 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985AbXCVOta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:49:30 -0400
Date: Thu, 22 Mar 2007 20:26:49 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, pj@sgi.com,
       Sam Vilain <sam@vilain.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org, dev@sw.ru
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070322145649.GB13127@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com> <45EF5E71.7090101@vilain.net> <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com> <45EF793C.1000700@vilain.net> <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com> <45EF83CB.9080903@vilain.net> <6599ad830703080110i33405501tb12bf8e58bf829c9@mail.gmail.com> <20070309165017.GF5948@sergelap.austin.ibm.com> <20070322140814.GA20796@in.ibm.com> <20070322143909.GC6981@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322143909.GC6981@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 09:39:09AM -0500, Serge E. Hallyn wrote:
> > What troubles will mounting both cpuset and ns in the same hierarchy
> > cause?
> 
> Wow, don't recall the full context here.

Sorry to have come back so late on this :)

> But at least with Paul's container patchset, a subsystem can only be mounted 
> once.  So if the nsproxy container subsystem is always mounted by itself, 
> then you cannot remount it to bind it with cpusets.

Sure ..I was thinking of mounting both ns and cpuset in same hierarchy
for first time itself.

-- 
Regards,
vatsa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751311AbXCHLeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbXCHLeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 06:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbXCHLeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 06:34:16 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44162 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXCHLeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 06:34:15 -0500
Date: Thu, 8 Mar 2007 17:09:41 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Paul Menage" <menage@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       sam@vilain.net, akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru,
       xemul@sw.ru, containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070308113941.GC29051@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <6599ad830703070946s1c6c0535oadff0a109731a4f9@mail.gmail.com> <m1649cbq6n.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1649cbq6n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 04:16:00PM -0700, Eric W. Biederman wrote:
> I think implementation wise this tends to make sense.
> However it should have nothing to do with semantics.
> 
> If we have a lot of independent resource controllers.  Placing the
> pointer to their data structures directly in nsproxy instead of in
> task_struct sounds like a reasonable idea 

Thats what the rcfs patches do.

> but it should not be user visible.

What do you mean by this? We do want the user to be able to manipulate
the resource parameters (which are normally present in the data
structures/resource objects pointed to by nsproxy -
nsproxy->ctlr_data[])

-- 
Regards,
vatsa

Return-Path: <linux-kernel-owner+w=401wt.eu-S2992717AbXCGXR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992717AbXCGXR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992722AbXCGXR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:17:57 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42705 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992717AbXCGXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:17:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Paul Menage" <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, sam@vilain.net,
       akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru, xemul@sw.ru,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>
	<6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	<20070307173031.GC2336@in.ibm.com>
	<20070307174346.GA19521@sergelap.austin.ibm.com>
	<6599ad830703070946s1c6c0535oadff0a109731a4f9@mail.gmail.com>
Date: Wed, 07 Mar 2007 16:16:00 -0700
In-Reply-To: <6599ad830703070946s1c6c0535oadff0a109731a4f9@mail.gmail.com>
	(Paul Menage's message of "Wed, 7 Mar 2007 09:46:35 -0800")
Message-ID: <m1649cbq6n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul Menage" <menage@google.com> writes:

> No, Sam was saying that nsproxy should be the object that all resource
> controllers hook off.

I think implementation wise this tends to make sense.
However it should have nothing to do with semantics.

If we have a lot of independent resource controllers.  Placing the
pointer to their data structures directly in nsproxy instead of in
task_struct sounds like a reasonable idea but it should not be user
visible.

Eric

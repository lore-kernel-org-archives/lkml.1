Return-Path: <linux-kernel-owner+w=401wt.eu-S965696AbXCGWN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965696AbXCGWN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965695AbXCGWN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:13:57 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49285 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965698AbXCGWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:13:56 -0500
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
	top of nsproxy!
From: Dave Hansen <hansendc@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, pj@sgi.com,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       akpm@linux-foundation.org
In-Reply-To: <20070307215919.GA2110@sergelap.austin.ibm.com>
References: <20070301133543.GK15509@in.ibm.com>
	 <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	 <20070307173031.GC2336@in.ibm.com>
	 <20070307174346.GA19521@sergelap.austin.ibm.com>
	 <20070307180055.GC17151@in.ibm.com>
	 <20070307205846.GB7010@sergelap.austin.ibm.com>
	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	 <20070307215919.GA2110@sergelap.austin.ibm.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 14:13:46 -0800
Message-Id: <1173305626.868.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 15:59 -0600, Serge E. Hallyn wrote:
> Space saving was the only reason for nsproxy to exist.
> 
> Now of course it also provides the teensiest reduction in # instructions
> since every clone results in just one reference count inc for the
> nsproxy rather than one for each namespace. 

If we have 7 or 8 namespaces, then it can save us a significant number
of atomic instructions on _each_ of the refcounts, plus touching all of
the cachelines, etc...

-- Dave


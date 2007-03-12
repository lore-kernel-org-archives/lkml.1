Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbXCLVPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbXCLVPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbXCLVPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:15:53 -0400
Received: from watts.utsl.gen.nz ([202.78.240.73]:40596 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXCLVPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:15:52 -0400
Message-ID: <45F5C301.8090500@vilain.net>
Date: Tue, 13 Mar 2007 10:15:45 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: vatsa@in.ibm.com
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dev@sw.ru, xemul@sw.ru, pj@sgi.com, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers
 on top of nsproxy!
References: <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <20070309163430.GN6504@in.ibm.com> <6599ad830703091409s3d233829gb8f0afbfd2883b15@mail.gmail.com> <20070312150756.GB24742@in.ibm.com> <20070312155643.GA12893@sergelap.austin.ibm.com> <20070312162045.GD12176@in.ibm.com>
In-Reply-To: <20070312162045.GD12176@in.ibm.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> On Mon, Mar 12, 2007 at 10:56:43AM -0500, Serge E. Hallyn wrote:
>   
>> What's wrong with that?
>>     
>
> I had been asking around on "what is the fundamental unit of res mgmt
> for vservers" and the answer I got (from Herbert) was "all tasks that are
> in the same pid namespace". From what you are saying above, it seems to
> be that there is no such "fundamental" unit. It can be a random mixture
> of tasks (taken across vservers) whose resource consumption needs to be
> controlled. Is that correct?
>   

Sure, for instance, all postgres processes across all servers might be
put in a different IO and buffercache use container by the system
administrator.

Sam.


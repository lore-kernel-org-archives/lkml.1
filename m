Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZAOLh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZAOLh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZAOLhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:37:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:33453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZAOLhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:37:11 -0500
Message-ID: <496F1FA6.6050204@kernel.org>
Date: Thu, 15 Jan 2009 20:36:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu>
In-Reply-To: <20090115113230.GH22850@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Jan 2009 11:36:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Is there any interim tree for us to pull into -tip? I'd rather not let 
> this grow too big, it will be harder and harder to debug any regressions. 
> Gradual progress is a lot more debuggable. Your initial patchset is 
> fantastic already (gives a ~0.2% kernel image size saving for defconfig), 
> so it's a very good start.

Sans the last patch (I'm still working on it), the git tree is at...

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=x86-percpu-zerobased
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-percpu-zerobased

And this happens to be the third time I wrote the above addresses in
this thread.  :-)

Thanks.

-- 
tejun

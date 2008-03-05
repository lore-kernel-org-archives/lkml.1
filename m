Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbYCEXL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbYCEXL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933553AbYCEXJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:09:19 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:52692 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563AbYCEXJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:09:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=oj5r69Z9s8b8q7uH7zCvCzpyTh9LfNo0PLoNoyEUUV1beGtMcxZyV/xsZRuWe4rBBmNnmnCrTYW71F1vkpCS/aY9ydseQ3skW2sp1ewEqHjVNwKg1Tx8mIS/NbwyZLokplhfer5y81lF7HLMTg1T5sJoUnki+VzJ7msFmyjlCkc=
Date: Thu, 6 Mar 2008 01:06:04 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       bunk@kernel.org, chrisw@sous-sol.org, eparis@parisplace.org,
       adobriyan@sw.ru, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH -v5 -mm] LSM: Add security= boot parameter
Message-ID: <20080305230604.GB6746@ubuntu>
References: <20080302074912.GA3215@ubuntu> <20080302105946.GA6406@ubuntu> <Xine.LNX.4.64.0803031910170.6729@us.intercode.com.au> <20080303153510.GA6963@ubuntu> <1204559642.23738.63.camel@moss-spartans.epoch.ncsc.mil> <20080303212433.GA12998@ubuntu> <Xine.LNX.4.64.0803040906380.21610@us.intercode.com.au> <20080304030407.GA25686@ubuntu> <20080305142948.3d391d84.akpm@linux-foundation.org> <20080305225628.GA6746@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305225628.GA6746@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 12:56:28AM +0200, Ahmed S. Darwish wrote:
> On Wed, Mar 05, 2008 at 02:29:48PM -0800, Andrew Morton wrote:
> > On Tue, 4 Mar 2008 05:04:07 +0200
> > "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:
> > 
> > Can chosen_lsm[] be __initdata?
> > 
> 
> You're the expert ;), I don't really understand the difference.
> 

After being a good citizen and reading the comments in init.h, I think
yes it should be marked so. even though we use it from init_smk_fs
since init_smk_fs is also marked as __init.

Thank you,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com


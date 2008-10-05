Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYJEMFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYJEMFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 08:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYJEMFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 08:05:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:14849 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbYJEMFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 08:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bEGxz4C1mbgXg27qPNUtA5GNvxEHphdPZsTVbwG25FvRBw8UVHkNyioV3beFOPu+7a
         JCv1V85t60TmKs7fLaTMhykab1dgXQMmhf8PNHHC1Sr7iVfdBaEe37M7bEeTtYvzPyJq
         szd3o24ZwPPTO0V4l/ZmBcmwzzbSv91mkA9vY=
Date: Sun, 5 Oct 2008 20:05:36 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 2/2] Suppress false "mtrr all empty" warning message
	when running as VMware guest
Message-ID: <20081005120536.GA4543@yantp.cn.ibm.com>
Mail-Followup-To: Pavel Machek <pavel@suse.cz>,
	Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	joerg.roedel@amd.com, rjmaomao@gmail.com,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
References: <a120cfa37281607d8dc361deda1a35419accd193.1222258080.git.elliot.li.tech@gmail.com> <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com> <20081001200351.GA2121@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001200351.GA2121@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 10:03:51PM +0200, Pavel Machek wrote:
> Hi!
> 
> Subject says: Suppress false "mtrr all empty"  .... would you explain
> why is the message false? I believe it is very true, and points out
> fact that VMWare virtualization fails to simulate MTRR-s.
> 
> IMO VMWare should just fix their emulator.

You are right, to some degree. Actually I have no strong evidence to
support this either.  Since KVM doesn't set MTRR, by hunch I thought
VMware might having similar shortages. Also nothing bad can be
observed after the system booted, so I guessed that warning was
useless. Moreover, none other OSes (include old Linux kernels) is
complaining about this in VMware so users of VMware might think 2.6.27
is buggy on this.

Hope someone from VMware could clear this up.  I think they are
working on this problem followed this thread. I'd be happy to help.

-- 
Li, Yan

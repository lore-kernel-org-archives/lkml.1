Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZIWWXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZIWWXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZIWWXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:23:31 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:53462 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZIWWXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UiVo+gPUp4VwN4sxnEO4U2pXVSpWyxWlCoY4HsO98HZBfmG/9Nf+w0NZH3GvwDqRMm
         Y5z5PVDvfQ0+PNXhtFkuq/5z+U5wYmap7/IGGSQH8pC4hwYOuofQXUglAxt08AYYtrZp
         6gExvauTujNZQZBdvoLUV1dan1/rmTzjF5c8g=
Date: Thu, 24 Sep 2009 00:23:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Kprobes core/tracing/profiling
	updates
Message-ID: <20090923222325.GB5190@nowhere>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com> <20090923105252.GA32176@elte.hu> <20090923212438.GA5190@nowhere> <20090923214642.GA30061@elte.hu> <20090923221356.GA23390@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923221356.GA23390@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 12:13:56AM +0200, Ingo Molnar wrote:
> 
> got this post-test failure with the new kprobes bits:
> 
>  make[2]: `scripts/unifdef' is up to date.
>    TEST    posttest
>  Error: c145cf71:        f3 0f a6 d0             repz xsha256 



Ah, xsha256 does not seem to be in the instruction table of the
decoder.


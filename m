Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbXEYXvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbXEYXvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXEYXu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:50:58 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:40157 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753484AbXEYXu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:50:57 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from compressed boot wrapper
Date: Fri, 25 May 2007 16:50:50 -0700
User-Agent: KMail/1.9.6
Cc: Ben Collins <ben.collins@ubuntu.com>, Andi Kleen <andi@firstfloor.org>,
       Ben Collins <bcollins@ubuntu.com>, linux-kernel@vger.kernel.org
References: <98cd38b5.git.bcollins@ubuntu.com> <200705251638.37489.jbarnes@virtuousgeek.org> <465774AD.8020408@zytor.com>
In-Reply-To: <465774AD.8020408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251650.50471.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 25, 2007 4:43:41 H. Peter Anvin wrote:
> Jesse Barnes wrote:
> > Right, but you're special that way.  And moreover, you would know how to
> > add such debug statements as needed.  But is this output something we
> > really need enabled unconditionally for everyone?
>
> *I* can do that, yes, but I usually don't have access to the platform in
> question.
>
> As such I really don't want to see this as a compilation option.  Make
> it a runtime option[*] so the user with the problematic machine.
>
> > I personally don't care that much, aside from the feeling that we have
> > way too many printks in general...
>
> [*] FWIW, my setup rewrite has a proper command-line parser in it, so we
> can use the command line from the start.

Yeah, that sounds much better.  Then it can just be under the usual 'debug' 
command line option.

Jesse

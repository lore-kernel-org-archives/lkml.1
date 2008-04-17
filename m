Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYDQVsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYDQVsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYDQVsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:48:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51311 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYDQVsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:48:07 -0400
Date: Thu, 17 Apr 2008 14:28:49 -0700
From: Greg KH <greg@kroah.com>
To: Richard MUSIL <richard.musil@st.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: Problem with accessing stable git over http
Message-ID: <20080417212849.GA17653@kroah.com>
References: <47EA26E4.8060602@st.com> <20080404050718.GE23796@1wt.eu> <47F5E701.6020706@st.com> <4804A58E.5070104@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4804A58E.5070104@st.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 02:54:38PM +0200, Richard MUSIL wrote:
> Just to give an update on the topic. I tried to clone stable 2.6.24.y
> branch and got a bit more info then on fetch:
> 
> > rmusil@prglx09 ~ $ git clone http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git linux-2.6.24.y
> > Initialized empty Git repository in /home/rmusil/linux-2.6.24.y/.git/
> > Cannot get remote repository information.
> > Perhaps git-update-server-info needs to be run there?
> > rmusil@prglx09 ~ $
> 
> This is from machine which is behind proxy, but I tried it from another
> one, which has direct access and got exactly the same output.
> Is it possible that perhaps git-update-server-info should be run there?
> Who is responsible for the repository maintenance?
> So far it looks like the http access is simply not set up on the repo,
> even though it is advertised on project web page.
> 
> Greg, could you help me with this?

I've now run git-update-server-info on that repo, let me know if that
solves the problem or not.

thanks,

greg k-h

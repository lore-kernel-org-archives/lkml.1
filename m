Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYLJM7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYLJM7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 07:59:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYLJM6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 07:58:51 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:54798 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYLJM6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 07:58:51 -0500
Date: Wed, 10 Dec 2008 14:00:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] makesystem: revive cscope target
Message-ID: <20081210130017.GA12939@uranus.ravnborg.org>
References: <1228911013-25641-1-git-send-email-jirislaby@gmail.com> <20081210124120.GA12784@uranus.ravnborg.org> <493FBA3B.5010801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493FBA3B.5010801@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 01:46:51PM +0100, Jiri Slaby wrote:
> On 12/10/2008 01:41 PM, Sam Ravnborg wrote:
> > On Wed, Dec 10, 2008 at 01:10:13PM +0100, Jiri Slaby wrote:
> >> - export src and obj, so that we can check them in tags.sh
> >> - don't allow * expansion during sh function calls
> > 
> > What benefit does this patch give us?
> > We do not use $obj neither $src in tags.sh.
> 
> I'm confused...
> 
> git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
> says:
> # Do not use full path is we do not use O=.. builds
> if [ ${src} == ${obj} ]; then
>         tree=
> else
>         tree=${srctree}
> fi
> in scripts/tags.sh.

OK - forgot about that one.
Will apply your patches when I get at my Linux box.

	Sam

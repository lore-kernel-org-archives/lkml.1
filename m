Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYGYLmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYGYLmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYGYLmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:42:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYGYLmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:42:12 -0400
Subject: Re: git snapshots (Was: Re: merging branches remotely with git?)
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: Jack Howarth <howarth@bromo.msbb.uc.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080725112231.GA28411@digi.com>
References: <20080725112231.GA28411@digi.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 25 Jul 2008 12:42:02 +0100
Message-Id: <1216986122.7098.36.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 13:22 +0200, Uwe Kleine-König wrote:
> Hello,
> 
> > ps Which git represents the git patches (like 2.6.26-git11) which are
> > placed as patches on the www.kernel.org web page under the section
> > The latest snapshot for the stable Linux kernel tree is:.
> AFAIK there is no public tree that contains these tags.  But I have a
> little script that creates them.  See below.

Yeah, a public repo on git.kernel.org containing only the snapshot tags
would be immensely useful.

e.g. Fedora rawhide regularly ships snapshots, so it'd be really nice to
be easily look-up what's been merged since a given snapshot:

  $> git-fetch linus
  $> git-fetch snapshot-tags
  $> git-log v2.6.26-git12..linus/master

(That is, assuming the snapshot script couldn't just push the tags to
Linus's repo ...)

Cheers,
Mark.


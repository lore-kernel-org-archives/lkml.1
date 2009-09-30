Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbZI3Ukf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbZI3Ukf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZI3Uke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:40:34 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:65312 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZI3Ukd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GLKdyGSKW7F8dC6irxZ3wwYm/WI7zHl/vvtfz1igO6WwFpE4vfyczftpFzLKvTSMYW
         dP0S685A8QkZPgbxBDY/wANpd3q8PUlMiNyroBUa8lCZhzHU/4Sa2tZlBw17rxBcVH1R
         +RfMNE3xBcAujTeFbq/ZOwPywbGB0D1DmTatU=
From: Jakub Narebski <jnareb@gmail.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: How can I download a git commit as a diff patch?
Date: Wed, 30 Sep 2009 22:40:16 +0200
User-Agent: KMail/1.9.3
Cc: Alejandro Riveira =?iso-8859-1?q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Andy <genanr@emsphone.com>,
       linux-kernel@vger.kernel.org, git@vger.kernel.org
References: <20090930154410.GA31502@thumper2> <m3tyyk9ost.fsf@localhost.localdomain> <20090930202527.GB22159@csclub.uwaterloo.ca>
In-Reply-To: <20090930202527.GB22159@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909302240.17729.jnareb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009, Lennart Sorensen wrote:
> On Wed, Sep 30, 2009 at 01:10:51PM -0700, Jakub Narebski wrote:

> > Or better yet, if given installation of gitweb supports it, on the
> > 'patch' link just on the right of 'raw' view.  Such patch can be
> > applied better by git-am (but both should work for GNU patch or
> > git-apply).
> > 
> > Yes, by default for merges the 'commitdiff' view (and the 'raw'
> > version, i.e. 'commitdiff_plain' view) shows **combined** diff of
> > changes brought by merge (see git-diff manpage for details on this
> > format).
> > 
> > For merge commit you have to choose which of parents you want to have
> > diff from.  Go to 'commit' view, there in the header would be two or
> > more parents.  Click on the 'diff' link beside chosen parent, check if
> > it is the diff you want to get, and then click on 'patch' (or 'raw')
> > link.
> 
> Is there a git command to show me a diff I can use with patch if I want to
> select a given patch as long as I can tell it which tree I want to follow?
> I don't care to use gitweb if I can do it with the command line git.

You can specify parent explicitely: "git diff <rev>^1 <rev>" for diff
to first parent, e.g. "git diff HEAD^ HEAD".

> 
> git show obviously shows the git combined diff format, at least by default.
> 
> Or is the idea of trying to use the diff from the merge commit just
> silly in the first place?

Just so you know that this single diff is not enough to redo a merge.
It is only partial information.


BTW. there is also "git diff-tree -m <rev>") to show diff to *all*
parents at once:

    -m    By default, `git-diff-tree --stdin` does not show differences for
          merge commits. With this flag, it shows differences to that commit
          from all of its parents. See also `-c`.

-- 
Jakub Narebski
Poland

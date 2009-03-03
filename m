Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZCCUyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZCCUyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZCCUyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:54:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:16769 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZCCUyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:54:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ktD1u0qiDns5stayp16a0At5yxHPQyGe0VUfZVyU/oTowJ8BfsMAZT1fS31Yownl/9
         eE/CsYtXr3w1E0dD15DMuNS08bbujQBxj+C/aw87jJDcbJ0FAa+PK3QaYqyn+PqbA6qQ
         42QodKFo1KnERx8mGuK+yg51H3ljZP3ygBVVQ=
MIME-Version: 1.0
In-Reply-To: <20090303200526.GA20236@ub>
References: <20090303200526.GA20236@ub>
Date: Tue, 3 Mar 2009 15:54:02 -0500
Message-ID: <170fa0d20903031254l7070294cwfa45ffdcc63b24d9@mail.gmail.com>
Subject: Re: ext3 duplicate entries with readdir
From: Mike Snitzer <snitzer@gmail.com>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 3:05 PM, Andries E. Brouwer
<Andries.Brouwer@cwi.nl> wrote:
> In a largish directory (21292 files) a scan using ext3 readdir
> found 21293 files, returning one entry twice.
>
> Google "ext3 readdir twice" gives me a handful of identical complaints.
> I see reports from 2002-2008.
> So, this is an old and well-known symptom but seemingly still not fixed,
> at least not in the kernel on this machine here.
> This report is for Fedora release 8 (Werewolf) with kernel 2.6.24.5.
>
> A 2002 post says "This is unfortunate, but the chances of our hitting
> this failure are relatively small".
>
> In http://www.redhat.com/archives/ext3-users/2008-August/msg00009.html
> tytso seems to understand what happens: a hash collision.
> But has this been fixed in the current tree?

Yes, it has been fixed, please see the following git commits:
6a897cf447a83c9c3fd1b85a1e525c02d6eada7d
8c9fa93d51123c5540762b1a9e1919d6f9c4af7c

Mike

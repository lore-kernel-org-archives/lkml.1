Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZAKOe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZAKOe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZAKOer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:34:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:55308 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZAKOeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:34:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DkvZvEhsUo5SvbQ7bBzTff7dPqSzEnqTl8iNnbbcE+t7QeUhHBjvt6A8NrRXMjKhHP
         xL9nF5mYmyNAQRr9RBrldf18BcSbgz4QJjtirNEHEjgoZoBSK0yYpSrSMaBeAq4nWIUl
         SubWbLft7d9xcZS6p8LKwKxmwFXrD9e/rfuMo=
Message-ID: <b637ec0b0901110634i7ea6fa7ao87ec22beb5a51c98@mail.gmail.com>
Date: Sun, 11 Jan 2009 15:34:44 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <nHCfeC0YLrE.A.7fD.xbfaJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
	 <nHCfeC0YLrE.A.7fD.xbfaJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been solved in 2.6.28-final and backported to 2.6.27.10 (a revert
of a Dave Kelikamp's commit).

On Sun, Jan 11, 2009 at 12:41 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12155
> Subject         : Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2008-11-23 16:17 (50 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5e55aa8db085dad1aabb4574c73c23c7ae571e7b
> References      : http://marc.info/?l=linux-kernel&m=122745709926361&w=4
>
>
>

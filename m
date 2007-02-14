Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbXBNO5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbXBNO5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 09:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327AbXBNO5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 09:57:35 -0500
Received: from mail.zopyra.com ([65.68.225.25]:60899 "EHLO zopyra.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322AbXBNO5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 09:57:34 -0500
From: Bill Lear <rael@zopyra.com>
Message-ID: <17875.9043.217255.863200@lisa.zopyra.com>
Date: Wed, 14 Feb 2007 08:57:23 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: Junio C Hamano <junkio@cox.net>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.0
In-Reply-To: <7vlkj1v3av.fsf@assigned-by-dhcp.cox.net>
References: <7vlkj1v3av.fsf@assigned-by-dhcp.cox.net>
X-Mailer: VM 7.18 under Emacs 21.1.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 13, 2007 at 19:14:16 (-0800) Junio C Hamano writes:
>The latest feature release GIT 1.5.0 is available at the usual places:
>...

I do think worth pointing out that, quite significantly, you can now
use git-daemon to push changes into a repo, something very handy for
private networks.

This is enabled by passing the --enable=receive-pack to the
git-daemon (usually in the [x]?inetd configuration).

This has the benefit of:

  1) More efficient git transport for both pushes and pulls.

  2) A less ugly URL to use: git://server/repo, instead of, say,
     ssh+git://server/path/to/repos/repo.

  3) Ability to easily move your repo without changing the URL in each
     client, by changing the URL in the git-daemon config file
     (xinetd) --- say, if you want to move your repo to a striped
     disk, or similar.


Bill

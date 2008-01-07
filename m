Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYAGKhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYAGKhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbYAGKhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:37:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbYAGKhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:37:18 -0500
From: Andreas Schwab <schwab@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: umount -l <path>, getcwd and /proc/<pid>/cwd inconsistent
References: <1199675850.3156.15.camel@raven.themaw.net>
X-Yow: I would like to urinate in an OVULAR, porcelain pool --
Date: Mon, 07 Jan 2008 11:37:15 +0100
In-Reply-To: <1199675850.3156.15.camel@raven.themaw.net> (Ian Kent's message
	of "Mon\, 07 Jan 2008 12\:17\:30 +0900")
Message-ID: <jemyrhaplw.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> Basically, from a bash shell, setting working directory to a mounted
> directory all is fine with "pwd" and "/proc/<pid>/cwd". Following a
> "umount - l" on the mount "pwd" continues to return the expected string
> but "/proc/<pid>/cwd" returns an empty string.

Builtin pwd just prints $PWD.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

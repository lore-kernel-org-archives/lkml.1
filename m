Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZEXOfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZEXOfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 10:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZEXOfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 10:35:16 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34475 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZEXOfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 10:35:15 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: dann frazier <dannf@debian.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove bashisms from scripts
References: <20090523171521.GA20612@ldl.fc.hp.com>
X-Yow: I'm continually AMAZED at th'breathtaking effects of WIND EROSION!!
Date: Sun, 24 May 2009 16:35:12 +0200
In-Reply-To: <20090523171521.GA20612@ldl.fc.hp.com> (dann frazier's message of
	"Sat, 23 May 2009 11:15:22 -0600")
Message-ID: <m2y6sm7en3.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dann frazier <dannf@debian.org> writes:

> +	printf "Usage:\n\t$0 <gcc-command>\n"

Don't put variable text in the format string, its expansion may contain
% characters, causing spurious errors.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

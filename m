Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbXFIUA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbXFIUA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759391AbXFIUAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:00:53 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbXFIUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:00:52 -0400
Message-ID: <466B06F1.5030509@zytor.com>
Date: Sat, 09 Jun 2007 13:00:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Albert Cahalan <acahalan@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: JIT emulator needs
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
In-Reply-To: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan wrote:
> There is an SE Linux execmem restriction that enforces W^X.
> Assuming you don't wish to just disable SE Linux, there are
> two ugly ways around the problem.

This should be fixed in SELinux, or more accurately the SELinux profile.

There is absolutely no other sane option.

Of course, you generally don't need a page to be writable and executable
at the same time, but the overhead of switching can be enormous.

	-hpa

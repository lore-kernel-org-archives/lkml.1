Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbXGXS7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbXGXS7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbXGXS7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:59:40 -0400
Received: from gw.goop.org ([64.81.55.164]:51118 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbXGXS7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:59:39 -0400
Message-ID: <46A64BDD.4080309@goop.org>
Date: Tue, 24 Jul 2007 11:58:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <20070724153916.GS21668@ftp.linux.org.uk> <46A62F35.2000501@goop.org> <20070724171455.GT21668@ftp.linux.org.uk> <46A636BB.7020706@zytor.com>
In-Reply-To: <46A636BB.7020706@zytor.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Could it be a gcc version difference?
>   

Likely.  Well, we can always try it and see how much crap turns up.  If
gcc keeps quiet about it, its certainly an improvement over the dummy loop.

    J

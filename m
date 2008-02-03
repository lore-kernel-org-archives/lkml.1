Return-Path: <linux-kernel-owner+w=401wt.eu-S936596AbYBCJy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936596AbYBCJy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 04:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761024AbYBCJyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 04:54:49 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:39404 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753657AbYBCJyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 04:54:49 -0500
From: Frank Seidel <frank@f-seidel.de>
To: Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] Remove unneeded code in sys_getpriority
Date: Sun, 3 Feb 2008 10:54:45 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080203030429.GB7459@ubuntu>
In-Reply-To: <20080203030429.GB7459@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802031054.45604.frank@f-seidel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 February 2008 04:04, Rabin Vincent wrote:
> This check is not required because the condition is always true.
> ...
> -				if (niceval > retval)
> -					retval = niceval;
> +				retval = 20 - task_nice(p);

Thats surely correct, but on the other hand currently those
case blocks are quite independet of their possition/could easily
be rearranged now .. or think of another case is put ahead.
Then this could mess up things.

Thanks,
Frank

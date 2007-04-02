Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbXDBMwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbXDBMwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934032AbXDBMwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:52:00 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:48929 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934030AbXDBMwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:52:00 -0400
Date: Mon, 2 Apr 2007 14:52:12 +0200
From: Olaf Hering <olaf@aepfle.de>
To: John Williams <jwilliams@itee.uq.edu.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ENOENT creating /dev/root on MTD RAM partition
Message-ID: <20070402125212.GA11522@aepfle.de>
References: <4610A598.4050206@itee.uq.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4610A598.4050206@itee.uq.edu.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, John Williams wrote:

> Any comments or suggestions on a possible cause or approach to track it
> down would be greatly appreciated.

Just a guess:
Check if '/dev' exists. I think it is now possible to not add the built-in
cpio archive with the mandatory /dev, /dev/console and /root entries.

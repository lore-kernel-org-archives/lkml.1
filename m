Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbYJPWef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbYJPWef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbYJPWe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:34:27 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:49318 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754964AbYJPWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:34:26 -0400
Date: Fri, 17 Oct 2008 00:45:22 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Chris Friesen <cfriesen@nortel.com>
cc: Bodo Eggert <7eggert@gmx.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kernel@vger.kernel.org, jeffschroeder@computer.org
Subject: Re: [PATCH] use tmpfs for rootfs v2
In-Reply-To: <48F7A971.3040500@nortel.com>
Message-ID: <alpine.LSU.0.999.0810170025090.14480@be1.lrz>
References: <alpine.LSU.0.999.0810161400160.5456@be1.lrz>
 <Pine.LNX.4.64.0810161507130.25933@anakin> <alpine.LSU.0.999.0810161936590.5051@be1.lrz>
 <48F7A971.3040500@nortel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Chris Friesen wrote:
> Bodo Eggert wrote:

> > Having tmpfs as the root filesystem allows you to get rid of the now unused
> > ramfs and free some kernel memory. On my system, that's about 5198 bytes
> > compared to having a ramfs root.
> 
> If you're not using swap, I assume the memory usage of tmpfs and ramfs would
> be identical?

I'd rather think having ACL, security labels etc. pp. will make tmpfs use 
more memory per file or directory. If you have no use for tmpfs' features,
you should use ramfs. But if you do want to use tmpfs in your system,
my guess is you'll be most likely be better off using no ramfs.
-- 
Good programming is 99% sweat and 1% coffee.

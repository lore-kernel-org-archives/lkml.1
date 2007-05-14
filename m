Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbXENXVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbXENXVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXENXVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:21:45 -0400
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:49727 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbXENXVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:21:45 -0400
From: Frank Seidel <frank@kernalert.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Trivial string form cleanups
Date: Tue, 15 May 2007 01:21:34 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <200705150053.11606.frank@kernalert.de> <4648E9EB.9010009@goop.org>
In-Reply-To: <4648E9EB.9010009@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705150121.34766.frank@kernalert.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007 00:59, Jeremy Fitzhardinge wrote:
> Saves sizeof(char *) per string too, but you need to be careful none of
> these are being passed to sizeof or typeof.  Did you check for that in
> your conversions?

Yes, i did, but i just went through them again to make it sure
and i really couldn't see any sizeof, typeof or other suspicious usages
of those strings in this set of cleanups.

Thanks,
Frank

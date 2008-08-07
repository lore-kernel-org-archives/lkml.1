Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbYHGUbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbYHGUbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYHGUbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:31:37 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:50646 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbYHGUbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:31:36 -0400
Message-ID: <489B5BA5.7010209@skyrush.com>
Date: Thu, 07 Aug 2008 14:31:33 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: tty: ctrl-c not always echoed, especially under load
References: <48977C96.2090005@skyrush.com>	<20080805001129.72d06e60@lxorguk.ukuu.org.uk>	<489A06D9.1080600@skyrush.com> <20080807203716.4a9870f6@lxorguk.ukuu.org.uk>
In-Reply-To: <20080807203716.4a9870f6@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> It should certainly occur if the output buffer is full but that shouldn't
> be the case for a few bytes. Agreed the current behaviour is unexpected
> and less than desirable so hack away.

Will do.  If you know, off-hand, which part of the code suppresses/holds
output while ^S is in effect, that would be of great help to me.  I'm
combing the tty kernel code, but nothing sticks out to me yet.

	Thanks, Joe

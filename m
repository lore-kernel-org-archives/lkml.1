Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbXHBUKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbXHBUKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759364AbXHBUKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:10:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39781 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbXHBUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:10:32 -0400
Date: Thu, 2 Aug 2007 21:10:30 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
Message-ID: <20070802201030.GP21089@ftp.linux.org.uk>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <Pine.LNX.4.64.0708022157310.9319@fbirervta.pbzchgretzou.qr> <9a8748490708021303h683a8be7if194a9314483c218@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490708021303h683a8be7if194a9314483c218@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 10:03:03PM +0200, Jesper Juhl wrote:
> I believe Guennadi's point is that gcc does not warn about it in the
> case of  c[4] = "0123"; but only in the case of c[4] = "01234" - so if
> we do have such initializations in the kernel we may have some bugs
> hiding there that gcc doesn't warn us about.

Who said it's a bug?  Or that all arrays of char have to contain '\0'
anywhere in them?

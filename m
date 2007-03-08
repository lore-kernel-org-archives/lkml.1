Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbXCHOks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbXCHOks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXCHOks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:40:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45776 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbXCHOkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:40:47 -0500
Subject: Re: [PATCH] tty: Turn on arbitary baud rate ioctls for i386
	platform
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20070308144445.31a4e3c4@lxorguk.ukuu.org.uk>
References: <20070308144445.31a4e3c4@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 08 Mar 2007 06:39:47 -0800
Message-Id: <1173364787.4568.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 14:44 +0000, Alan Cox wrote:
> Adds the needed TCGETS2/TCSETS2 ioctl calls, structures, defines and the
> like. Tested against the test suite and passes. Other platforms should need
> roughly the same change.


should this then really be in include/asm/* ? If everyone needs the same
change I'd think it should go into include/linux/* somewhere.
(if the answer is "the old ioctls were arch specific"... maybe the new
ones can fix that defect ;)



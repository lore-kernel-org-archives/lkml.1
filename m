Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbXI0OBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbXI0OBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXI0OBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:01:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35722 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbXI0OBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:01:33 -0400
Date: Thu, 27 Sep 2007 07:01:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file
 without options
Message-ID: <20070927070118.2bd4792e@laptopd505.fenrus.org>
In-Reply-To: <20070927142919.10b62f9b@the-village.bc.nu>
References: <20070927142919.10b62f9b@the-village.bc.nu>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 14:29:19 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> The early LFS work that Linux uses favours EFBIG in various places.
> SuSv3 specifically uses EOVERFLOW for this as noted by Michael (Bug
> 7253)


isn't this an ABI change?
What's the gain for doing this ABI change?

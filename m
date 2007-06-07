Return-Path: <linux-kernel-owner+w=401wt.eu-S1765690AbXFGPvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765690AbXFGPvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763391AbXFGPvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:51:33 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50391 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbXFGPvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:51:32 -0400
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
	used
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20070607163808.19984208@the-village.bc.nu>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
	 <1181133010.4096.26.camel@pmac.infradead.org>
	 <20070606160310.27d6d3b8@the-village.bc.nu>
	 <1181150998.2785.13.camel@pmac.infradead.org>
	 <20070607163808.19984208@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 16:50:21 +0100
Message-Id: <1181231421.2785.68.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 16:38 +0100, Alan Cox wrote:
> If your termios and termios2 structures differ in size then you need to
> copy the right number of bytes or you won't get speed values into the
> kernel. If they are the same size it wont matter.

+/* Yay. A third identical definition of the same structure. */
+struct termios2 {

-- 
dwmw2


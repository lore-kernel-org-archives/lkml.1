Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbXFYPbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbXFYPbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXFYPbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:31:42 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41212 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbXFYPbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:31:41 -0400
X-Originating-Ip: 74.102.207.204
Date: Mon, 25 Jun 2007 11:27:37 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
In-Reply-To: <1182785195.26621.9.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0706251126070.8881@localhost.localdomain>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
  <1182469678.2704.16.camel@laptopd505.fenrus.org> 
 <467fd703.72QYmCwQ6G3TPmF6%Joerg.Schilling@fokus.fraunhofer.de>
 <1182785195.26621.9.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Arjan van de Ven wrote:

> there is no __KERNEL__ in the "make headers_install"'d kernel headers.

not quite technically true, as "unifdef" isn't smart enough to factor
out __KERNEL__ if it's part of a larger, logical expression involving
the "||" operator.  but that's being admittedly nitpicky.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

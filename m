Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbYFYXCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbYFYXCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYFYXCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:02:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYFYXCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:02:00 -0400
Subject: Re: [PATCH] dabusb: use request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Deti Fliegl <deti@fliegl.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, jaswinder@infradead.org, bunk@kernel.org
In-Reply-To: <1214221558.27974.33.camel@shinybook.infradead.org>
References: <1214219201.27974.21.camel@shinybook.infradead.org>
	 <20080623112004.GA26516@infradead.org>
	 <1214221558.27974.33.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 00:01:54 +0100
Message-Id: <1214434914.10393.21.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 12:46 +0100, David Woodhouse wrote:
> That makes a certain amount of sense, I suppose, and would certainly
> reduce the litter of new _FIRMWARE options, as well as the pointless
> whining that some people like to repeat at _each_ patch when we default
> them to 'N'. I could do it something like below...

I've reworked the git tree to do it that way.

-- 
dwmw2


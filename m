Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369Ab0AYKK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0AYKK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 05:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912Ab0AYKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 05:10:58 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:21712 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776Ab0AYKK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 05:10:57 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1001250424540.4502@p34.internal.lan>
References: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan>
	 <9883.1264397678@localhost>
	 <alpine.DEB.2.00.1001250424540.4502@p34.internal.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 10:10:41 +0000
Message-ID: <1264414241.16526.84480.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: High pitch noise when ACPI processor module is loaded.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=ZtHxNT4mZm3rCuM0SmWmgWxeBwJsziC8EqOrwwVkrhA= c=1 sm=0 a=d1K1jNoeil8A:10 a=YGZWEGVs2tF9HH4jfA8A:9 a=a55YSaq2mKu1YluHJZmqdlCMtJ0A:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 04:26 -0500, Justin Piszcz wrote:
> So the question remains, is it possible to utilize turbo boost (in Linux)
> without the high pitch noise from the ACPI processor module?

I have to use the max_cstate=2 option to processor.ko in order to not
have a similar high pitch noise. I suppose you might get away higher
values of max_cstate depending on your hardware. Battery life doesn't
seem to be too adversely impacted.

Ian.

-- 
Ian Campbell
Current Noise: Ephel Duath - Ruins (Deep Blue And Violet)

Hmm...  Which would do a better job at driving physicists crazy?  Travel
faster than light, or a floating-point boolean value?
		-- Michael Mol


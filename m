Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZESQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZESQC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZESQCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:02:21 -0400
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:65022 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZESQCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:02:21 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 May 2009 12:02:20 EDT
From: Ian Campbell <ijc@hellion.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, jeremy@goop.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       gregkh@suse.de, okir@suse.de
In-Reply-To: <20090520002955R.fujita.tomonori@lab.ntt.co.jp>
References: <20090518084052.GD10687@elte.hu>
	 <20090519142626X.fujita.tomonori@lab.ntt.co.jp>
	 <20090519130300.GB6238@elte.hu>
	 <20090520002955R.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Tue, 19 May 2009 16:56:37 +0100
Message-Id: <1242748597.22654.44.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: Where do we stand with the Xen patches?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=GMTY6ZCfsGoA:10 a=UU1a1liyotcA:10 a=em7P0ZmFGsH9V_GMfAkA:9 a=dj8d0RQMfG2ILESP-w0A:7 a=6udagkCdlg0FwGJlisz1CnVQshgA:4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 00:30 +0900, FUJITA Tomonori wrote:
> 
> We need these hooks but as I wrote above, they are
> architecture-specific and we should handle them with the architecture
> abstraction (as we handle similar problems) however we can't due to
> dom0 support.

I don't understand this. What exactly about the dom0 support patch
prevents future abstraction here?

The dom0 hooks would simply move into the per-arch abstractions as
appropriate, wouldn't they?

Ian.
-- 
Ian Campbell
Current Noise: Mondo Generator - Simple Exploding Man

"We are on the verge: Today our program proved Fermat's next-to-last theorem."
		-- Epigrams in Programming, ACM SIGPLAN Sept. 1982


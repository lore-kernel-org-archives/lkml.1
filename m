Return-Path: <linux-kernel-owner+w=401wt.eu-S1761002AbYD3Pf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbYD3Pf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYD3PfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:35:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:60791 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYD3PfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k2/n8+CPwcGdaElutkYOeJBrk26SB+Trdn/yfOQ+IL/CTZN0or02zMtJSuUa+zeyC3P2Ajzh8iCL+D7zXNPffaEiBL3iB/OADKLse5oNbSD2pZysdpTBxAHWrWPUooarBrtDC3VxzYaxJ1Qm0CpHUmpZ1c/IZ4ggOCd7WXNcK7A=
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Al Viro <viro@ZenIV.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <20080430123536.GD30735@elte.hu>
References: <1209268817.14173.43.camel@brick>
	 <20080427042051.GL5882@ZenIV.linux.org.uk> <20080429210435.GA23008@elte.hu>
	 <20080430064603.GA3602@atjola.homenet> <20080430093233.GD23528@elte.hu>
	 <20080430121738.GA4559@atjola.homenet>  <20080430123536.GD30735@elte.hu>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 08:35:34 -0700
Message-Id: <1209569734.24729.65.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 14:35 +0200, Ingo Molnar wrote:
> We for one simply concentrate on the the things that we think makes it 
> more likely to find bugs. For example we build and boot x86.git with 
> many different configs before every pull request. In practice that 
> catches far more tester-critical bugs than Sparse - and we know that 
> simply from the fact because we use both methods and have a good 
> comparison of the results. We also work on automating Sparse checks in 
> the future but as i said it, it's not easy.
> 

That's precisely why I've been sending all of the sparse cleanup patches
lately, to try and get the output down to something more managable.  You
may want to upgrade your sparse to one that understands __cold though.

Harvey


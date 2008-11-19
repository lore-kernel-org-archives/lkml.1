Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbYKSSkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbYKSSkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYKSSkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:40:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:54711 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYKSSkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:40:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QGl2nxswlcmZxg5Iost50N5ZsHnogKEc6gzC/QRcB0Z4/XpenbWysasSMuO3M8KS3j
         sJu1LrGhu2FFQjq4DXh4t0bSAFVWV9n+hzHp6oUOtgqeYn2GzyZXIsd2thBCUs4MGSI/
         AjiPaI/nheSYG2EpKrlFb2HNMPk14hqT77qHQ=
Date: Wed, 19 Nov 2008 18:40:14 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: fix undeclared variables
Message-ID: <20081119184014.GD22898@hack.voiplan.pt>
References: <20081118174250.GE3185@hack.voiplan.pt> <20081118192626.GU28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081118192626.GU28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 07:26:26PM +0000, Al Viro wrote:
>On Tue, Nov 18, 2008 at 05:42:51PM +0000, Am??rico Wang wrote:
>> 
>> Fix three compile errors about undeclared variables in
>> arch/um/kernel/mem.c.
>
>And what, pray tell, would initialize it?

Sorry, I can't fully understand you. I got the following error:

arch/um/kernel/mem.c: In function ‘init_highmem’:
arch/um/kernel/mem.c:177: error: ‘pkmap_page_table’ undeclared (first
use in this function)
arch/um/kernel/mem.c:177: error: (Each undeclared identifier is
reported only once
arch/um/kernel/mem.c:177: error: for each function it appears in.)

Thanks.

-- 
"Sometimes the only way to stay sane is to go a little crazy."


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYEHIAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYEHIAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759232AbYEHIAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:00:43 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:60579 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759306AbYEHIAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:00:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Linux-fbdev-devel] [PATCH 6/9] viafb: VIA Frame Buffer Device Driver
Date: Thu, 8 May 2008 16:00:38 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67EE3@exchtp03.taipei.via.com.tw>
In-Reply-To: <20080508071809.GA11121@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 6/9] viafb: VIA Frame Buffer Device Driver
Thread-Index: Aciw4B5wqH1fbjs+SQC7dzCmagdi9gAAQndQ
From: <JosephChan@via.com.tw>
To: <santiago@crfreenet.org>
Cc: <akpm@linux-foundation.org>, <geert@linux-m68k.org>,
       <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 May 2008 08:00:39.0993 (UTC) FILETIME=[9B507290:01C8B0E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ondrej,

Thanks for your reminding, I will put the configuration file to Documentation/fb next time.
As I know, it should contains some other modes. l check with our engineers later.

BRs,
Joseph Chan 

-----Original Message-----
From: Ondrej Zajicek [mailto:santiago@crfreenet.org] 
Sent: Thursday, May 08, 2008 3:18 PM
To: Joseph Chan
Cc: akpm@linux-foundation.org; geert@linux-m68k.org; linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 6/9] viafb: VIA Frame Buffer Device Driver

On Wed, May 07, 2008 at 07:09:42PM +0800, JosephChan@via.com.tw wrote:
> diff -Nur a/drivers/video/via/viafb.modes b/drivers/video/via/viafb.modes
> --- a/drivers/video/via/viafb.modes	1969-12-31 19:00:00.000000000 -0500
> +++ b/drivers/video/via/viafb.modes	2008-04-29 02:51:27.000000000 -0400
> @@ -0,0 +1,870 @@
> +#
> +#
> +#   These data are based on the CRTC parameters in
> +#
> +#       VIA Integration Graphics Chip
> +#       (C) 2004 VIA Technologies Inc.

Configuration file for fbset definitely shouldn't be here between C source files. If it is needed, then it should be somewhere in Documentation/fb .

BTW, Are these modes common VESA modes (DVT, GTF or CVT)  or some other modes. In first case there is probably no reason to include them.

--
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org) OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net) "To err is human -- to blame it on a computer is even more so."


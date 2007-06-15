Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbXFONi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbXFONi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbXFONiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:38:21 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:56328 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753607AbXFONiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:38:20 -0400
Date: Fri, 15 Jun 2007 15:38:23 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Bernd Paysan <bernd.paysan@gmx.de>
Cc: Paulo Marques <pmarques@grupopie.com>, Al Viro <viro@ftp.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615133823.GC11830@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Bernd Paysan <bernd.paysan@gmx.de>,
	Paulo Marques <pmarques@grupopie.com>,
	Al Viro <viro@ftp.linux.org.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <20070614170902.GQ21478@ftp.linux.org.uk> <467178D3.6010204@grupopie.com> <200706151014.45383.bernd.paysan@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706151014.45383.bernd.paysan@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 10:14:44AM +0200, Bernd Paysan wrote:
>                                           Linus isn't in the positition to 
> change that unless he does a substantial change to the file, and also adds 
> a comment that this file is now GPLv2 only.

Which would only have effect on future additions, not the current
content of the file - of course.

Now - what if someone would write a patch for such a file (that was
'any version' before and then had a header added saying 'just version 2')
under the license 'version 2 or later'? This patch could be transformed
to 'just 2', and then applied to said source file - but, it could also
be added to the previous version of that file (without the new header)
as 'version 2 or later'.  Hence, the file can still be constructed at
any moment (provided the header is removed) as license 'version 2 or
later', UNLESS someone adds a *crucial* patch (that cannot be removed
as well, along with the header) that is explicitely made version 2
ONLY by its author.

Bottom line - adding a header to those files with "version 2 only"
by Linus is pointless.

-- 
Carlo Wood <carlo@alinoe.com>

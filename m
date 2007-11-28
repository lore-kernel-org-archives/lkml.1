Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbXK1JCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbXK1JCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXK1JCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:02:18 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:44180 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbXK1JCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:02:16 -0500
Date: Wed, 28 Nov 2007 10:00:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: murtuja bharmal <murtuja_bharmal@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Linux 2.6 kernel module compilation without using KBUILD
Message-ID: <20071128090046.GA15067@uranus.ravnborg.org>
References: <299272.92165.qm@web36708.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <299272.92165.qm@web36708.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:09:51AM -0800, murtuja bharmal wrote:
> Hello All,
>    
> I want to compile external linux kernel module without
> using KBUILD.
...
> Do we have any document which describe how to make
> kernel module without using KBUILD.

No.
Becasue building kernel modules without using kbuild is highly 
discouraged and vulnerable for all sort of config related issues.
As a simple example the module may become unuseable if just one
change is made to the configuration because this changes
the parameters passed to gcc which again affects the code
being built.

Can you try to enlighting why you want to avoid kbuild.
If you have a specific problem then maybe kbuild already can
do what you need.

	Sam

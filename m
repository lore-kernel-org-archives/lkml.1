Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbZFZKPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbZFZKPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 06:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZFZKPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 06:15:44 -0400
Received: from smtp4.welho.com ([213.243.153.38]:52215 "EHLO smtp4.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbZFZKPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 06:15:43 -0400
X-Greylist: delayed 1248 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2009 06:15:43 EDT
Date: Fri, 26 Jun 2009 12:54:54 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Russell King <linux@arm.linux.org.uk>,
       Antonino Daplas <adaplas@gmail.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 18/19] drivers/video: Use PCI_VDEVICE
Message-ID: <20090626095454.GH9980@sci.fi>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Russell King <linux@arm.linux.org.uk>,
	Antonino Daplas <adaplas@gmail.com>,
	Petr Vandrovec <vandrove@vc.cvut.cz>,
	Thomas Winischhofer <thomas@winischhofer.net>,
	linux-fbdev-devel@lists.sourceforge.net
References: <cover.1245906151.git.joe@perches.com> <198c226b3dfd003881e7f95b3fbbc8d433804b01.1245906153.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <198c226b3dfd003881e7f95b3fbbc8d433804b01.1245906153.git.joe@perches.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 10:13:34PM -0700, Joe Perches wrote:
<snip>
> +	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_RAGE128_TS), rage_128_ultra },
> +	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_RAGE128_TT), rage_128_ultra },
> +	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_RAGE128_TU), rage_128_ultra },
>  	{ 0, }
>  };

Perhaps there should be a PCI_VDDEVICE() or something for this type of
stuff? Would make things even shorter.

Also PCI_VDEVICE() does not use named initializers for some reason.
Might be worth fixing.

It seems your script missed atyfb. It could use PCI_VDEVICE() too.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/

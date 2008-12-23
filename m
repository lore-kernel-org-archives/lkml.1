Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbYLWOym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbYLWOym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYLWOyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:54:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYLWOyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:54:32 -0500
Date: Tue, 23 Dec 2008 09:54:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
       bug-parted@gnu.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.27.10: cannot mount xfs filesystem partition (12TiB) after
	reboot
Message-ID: <20081223145431.GA31057@infradead.org>
References: <alpine.DEB.1.10.0812230829420.4817@p34.internal.lan> <20081223134247.GA17750@infradead.org> <alpine.DEB.1.10.0812230950120.7572@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812230950120.7572@p34.internal.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 09:50:26AM -0500, Justin Piszcz wrote:
> 
> 
> On Tue, 23 Dec 2008, Christoph Hellwig wrote:
> 
> > On Tue, Dec 23, 2008 at 08:36:17AM -0500, Justin Piszcz wrote:
> >> Kernel = 2.6.27.10
> >> Parted = 1.8.8.git.2008.03.24-11.1
> >>
> >> Can anyone help explain the problem here?
> >
> > Can you post your kernel .config file?
> >
> 
> http://home.comcast.net/~jpiszcz/20081223/config-2.6.27.10.txt

Without CONFIG_EFI_PARTITION the kernel won't find your gpt labels.  See 

	http://xfs.org/index.php/XFS_FAQ#Q:_Why_does_my_.3E_2TB_XFS_partition_disappear_when_I_reboot_.3F


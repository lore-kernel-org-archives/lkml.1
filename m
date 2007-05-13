Return-Path: <linux-kernel-owner+w=401wt.eu-S934646AbXEMQaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646AbXEMQaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759154AbXEMQa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:30:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939AbXEMQa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:30:26 -0400
Date: Sun, 13 May 2007 12:30:23 -0400
From: Dave Jones <davej@redhat.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Message-ID: <20070513163023.GE27604@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain> <20070513160608.GA29024@redhat.com> <1179072655.3723.42.camel@mulgrave.il.steeleye.com> <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 11:18:35AM -0500, James Bottomley wrote:
 > On Sun, 2007-05-13 at 11:10 -0500, James Bottomley wrote:
 > > > -	depends on SCSI
 > > > +	depends on SCSI_SCAN_ASYNC
 > > 
 > > No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force the
 > > wait scan to be built in, which isn't the idea at all.
 > 
 > Plus SCSI_SCAN_ASYNC only sets the *default* for async scanning.  You
 > can alter this at boot time, so you could need the wait scan module even
 > with it set to N.

Ah, good point.

	Dave

-- 
http://www.codemonkey.org.uk

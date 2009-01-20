Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbZATOdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbZATOdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZATOc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:32:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZATOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:32:59 -0500
Date: Tue, 20 Jan 2009 09:32:57 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>,
       LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120143257.GA21073@infradead.org>
References: <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org> <20090120121335.GA19182@infradead.org> <20090120124515.GA31838@infradead.org> <4975D88B.7020906@gmail.com> <20090120140514.GA2976@infradead.org> <4975DE45.7050004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4975DE45.7050004@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 03:23:01PM +0100, Jacek Luczak wrote:
> I've applied it and now running ,,fixed'' kernel. What I've notice is:
> $ LC_ALL=C df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda1              20G  -40E   40E   -  /
> /dev/sda5              20G  -23E   23E   -  /home
> /dev/sda6              56G   56G  774M  99% /NORA
> /dev/sda7              45G   44G  1.2G  98% /MAGAZYN

Yeah, it's more of a hack.  If you drop the patch and just enable
CONFIG_LBD it should be fine.


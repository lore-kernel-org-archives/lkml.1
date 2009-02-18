Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZBRPaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZBRPaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZBRPaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:30:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:55996 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZBRPaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:30:06 -0500
Date: Wed, 18 Feb 2009 15:29:56 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [RESEND] binfmt_script: rewrite using parse_shell_args()
Message-ID: <20090218152956.GA15633@srcf.ucam.org>
References: <1234970162-10694-1-git-send-email-kirill@shutemov.name> <1234970162-10694-2-git-send-email-kirill@shutemov.name> <20090218151616.GC15195@srcf.ucam.org> <20090218152252.GB5270@epbyminw8406h.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218152252.GB5270@epbyminw8406h.minsk.epam.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 05:22:52PM +0200, Kirill A. Shutemov wrote:
> On Wed, Feb 18, 2009 at 03:16:16PM +0000, Matthew Garrett wrote:
> > On Wed, Feb 18, 2009 at 05:16:01PM +0200, Kirill A. Shutemov wrote:
> > > parse_shell_args() allows to use more than one argument in shebang.
> > 
> > As mentioned before, this breaks userspace ABI.
> 
> Do you have real world example of breakage?

Have you checked every script on every Linux system?
-- 
Matthew Garrett | mjg59@srcf.ucam.org

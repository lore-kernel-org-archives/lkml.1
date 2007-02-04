Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbXBDNXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbXBDNXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXBDNXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:23:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:21167 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbXBDNXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:23:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YvI7qD2MXyisADmQza4yaYlR2dMfoxnAQAWNLCd87/BpuPop2zkSA6TFJLQt7wvnzY/51VUXBCK+ci/sUfV+LtqJNvFl4od8qstd75T2AvHue5mCqu+J3oeaI4PqK5fuorxrNficCv+TXBajuzbP9Q7qfDWwv8tC1sD873HUFHI=
Date: Sun, 4 Feb 2007 16:21:15 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HIL small fix
Message-ID: <20070204132115.GA10026@cvg>
References: <20070204074758.GA10596@cvg> <200702041255.57835.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702041255.57835.deller@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 12:55:57PM +0100, Helge Deller wrote:
| Hello Cyrill,
| 
| thanks a lot for the patch.
| I've applied it to the PARISC-Linux git tree:
| http://git.parisc-linux.org/?p=linux-2.6.git;a=commit;h=2b1f35b1cdec70c3a0ee2d4174668597355b6041
| 
| Your patch made me aware of an unitialized spinlock in the code as well:
| http://lists.parisc-linux.org/pipermail/parisc-linux-cvs/2007-February/037203.html
| 
| Regards,
| Helge
| 
| On Sunday 04 February 2007, Cyrill V. Gorcunov wrote:
| > This patch adds a checking for errors in hil_keyb_init.
| > Also some extra spaces are removed.
| > 
| > Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
| > 
| > ---
| > 
| >  dvers/input/keyboard/hilkbd.c |  106 +++++++++++++++++++++++----------------
| >  1 files changed, 62 insertions(+), 44 deletions(-)

Hi, I'm glad to be useful ;)

		Cyrill


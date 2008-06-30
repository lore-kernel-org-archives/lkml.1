Return-Path: <linux-kernel-owner+w=401wt.eu-S1764386AbYF3VHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386AbYF3VHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762898AbYF3VGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:06:47 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:16579 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760495AbYF3VGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=xYQteycxw43hm8iTXpmtadKVoTJPwmeV7eoBYBC9OiGnsATTRNRpZfdXhpQi+Oa7cq
         OR83vhvW5tG7anpVudKtyf9y5P1HOazBR5i3nWA985x7As+FDRt8mLcUHCakFiE/NWNb
         xnWncrPreMeBTBDu+moiW/Yt4l9GIgwkuCjRA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] drivers/ide/ide-tape.c: remove double kfree
Date: Mon, 30 Jun 2008 22:45:00 +0200
User-Agent: KMail/1.9.9
Cc: Darren Jenkins <darrenrjenkins@gmail.com>,
       kernel Janitors <kernel-janitors@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       gadio@netvision.net.il
References: <1214692474.8254.22.camel@localhost.localdomain> <20080629162644.GA10023@gollum.tnic>
In-Reply-To: <20080629162644.GA10023@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806302245.00200.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 June 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> in case you haven't picked that one up already...
> 
> On Sun, Jun 29, 2008 at 08:34:34AM +1000, Darren Jenkins" wrote:
> > G'day people,
> > 
> > 
> > Coverity CID: 2336 USE_AFTER_FREE
> > 
> > drivers/ide/ide-tape.c ide_tape_kfree_buffer() double free's a pointer
> > (hint freed by an alias in first outer loop).
> > This patch simply removes the superfluous kfree().
> > 
> > 
> > 
> > Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>
> Acked-by: Borislav Petkov <petkovbb@gmail.com>

applied

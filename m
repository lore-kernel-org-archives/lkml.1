Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbYBYUqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbYBYUqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757729AbYBYUpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:45:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:41358 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbYBYUpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:45:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=ZgKHgzEI+m3FJZg2dGKGWD4un0Ix/IrDodmkn4gk1GO0IIhRMhKad9+drvEPJpIIBaLBrMvohAlsS1NnzZtUbcWUQv0klGQEmpUZccd3Z0cf7NFLbTm2Sa6kuO9V0Aq8pYzA/tuBeXkXKD7+70MZAr0+hpEazIYYX0UDrmgv2T4=
Date: Mon, 25 Feb 2008 21:45:43 +0100
To: Andreas Schwab <schwab@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       j-nomura@ce.jp.nec.com
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
Message-ID: <20080225204543.GA26788@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Andreas Schwab <schwab@suse.de>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
	j-nomura@ce.jp.nec.com
References: <jelk5k62uy.fsf@sykes.suse.de> <58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com> <20080218.135827.74754725.k-ueda@ct.jp.nec.com> <jek5kvisih.fsf@sykes.suse.de> <20080224163244.GA11998@gollum.tnic> <jehcfyffyp.fsf@sykes.suse.de> <002101c87759$0fb4f010$58f80d0a@brian> <jeejb0968h.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <jeejb0968h.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 08:38:22PM +0100, Andreas Schwab wrote:
> "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com> writes:
> 
> > I'm looking at this problem, but currently no idea why the conversion
> > to blk_end_request causes it.
> 
> cdrom_newpc_intr apparently never sets rq->sense_len.
> 

actually it does, see the code chunk around line 1188 in 2.6.25-rc2, for
example.

-- 
Regards/Gruﬂ,
    Boris.

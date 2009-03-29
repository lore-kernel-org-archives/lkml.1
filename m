Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbZC2Rvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbZC2Rvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 13:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZC2Rvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 13:51:35 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35952 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZC2Rvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 13:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=S0adevwNVtxBwyfLeGjoKslPV+5daE0bq7FdBnj8launCbYYszq4tnNljqgcwaYVv/
         9JlZ+9Xt69dIHfVg/ZU4VnEKYULehOcNNGhLdERibFNOU6LD0ZueySsMwpHHLyTsi97E
         RpJFjsNTDtlty1et8faH1fTi0OMMsSXKIoCOc=
Date: Sun, 29 Mar 2009 21:59:03 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Consolidate init_mm definition
Message-ID: <20090329175903.GB26405@x200.localdomain>
References: <20090326235116.GA26129@x200.localdomain> <20090329163857.GF7671@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090329163857.GF7671@hack>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 12:38:57AM +0800, Américo Wang wrote:
> On Fri, Mar 27, 2009 at 02:51:16AM +0300, Alexey Dobriyan wrote:
> >* create mm/init-mm.c, move init_mm there
> >* remove INIT_MM, initialize init_mm with C99 initializer
> >* unexport init_mm on all arches:
> >
> >  init_mm is already unexported on x86.
> >
> >  One strange place is some OMAP driver (drivers/video/omap/) which
> >  won't build modular, but it's already wants get_vm_area() export.
> >  Somebody should look there.
> >
> 
> Nice patch!
> 
> I don't know if my reply is too late or not.
> But, do we need a new C file just to hold the init_mm definition?

I dunno. I thought where could I stick it, and all files looked alien?

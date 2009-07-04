Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZGDPsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZGDPsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 11:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZGDPsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 11:48:10 -0400
Received: from kroah.org ([198.145.64.141]:44689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbZGDPsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 11:48:09 -0400
Date: Sat, 4 Jul 2009 08:42:52 -0700
From: Greg KH <greg@kroah.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: gregkh@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/vt6655: pointer to driver_data needs to be
 type long
Message-ID: <20090704154252.GC5056@kroah.com>
References: <4A442E7C.7070301@oss.ntt.co.jp>
 <20090702194952.GF10957@kroah.com>
 <4A4D61BE.2010807@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A4D61BE.2010807@oss.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 10:41:18AM +0900, Fernando Luis Vázquez Cao wrote:
> Greg KH wrote:
> > On Fri, Jun 26, 2009 at 11:12:12AM +0900, Fernando Luis Vázquez Cao wrote:
> >> Fix the compilation error below while at it.
> >>
> >> drivers/staging/vt6655/device_main.c:347: warning: cast from pointer to integer of different size
> >> drivers/staging/vt6655/device_main.c:347: error: initializer element is not constant
> >> drivers/staging/vt6655/device_main.c:347: error: (near initialization for ‘device_id_table[0].driver_data’)
> >>
> >> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > 
> > This patch doesn't apply :(
> > 
> > Care to resync off of tomorrow's linux-next tree?
> 
> It seems that a patch from Alan Cox (linux-next: 38d257422fb010e11180fc9c5794812f390aca74)
> which fixes this issue got merged first, so mine is not needed anymore if you are planning
> to send the fix to Linus before the next merge window. What are your plans?

Ok, i'll stick with Alan's fix for now.

thanks,

greg k-h

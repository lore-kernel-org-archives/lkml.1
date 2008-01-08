Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbYAHUDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbYAHUDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYAHUDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:03:18 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:36101 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbYAHUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:03:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mo/dF5iwBUwruehGV615m+xeVqHXl+g8K8T+29pbca+5B/WKrhKWUsTzSu/fVh5RktNFS/13WxkSl36vN5GUY1hz8/A8dwqQ1j7RgQubkrUGsHDuHly2B59erXBCTowpQ+sTmN+b1lSPYJSgLylS/u6pPO5lzCYcp77sHKYItkc=
Message-ID: <4d8e3fd30801081203l636c5923j7965efaa9c121c56@mail.gmail.com>
Date: Tue, 8 Jan 2008 21:03:13 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
In-Reply-To: <20080108200044.GI16309@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108164015.GC31504@one.firstfloor.org>
	 <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
	 <20080108200044.GI16309@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 9:00 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Jan 08, 2008 at 08:58:04PM +0100, Paolo Ciarrocchi wrote:
> > -static const struct file_operations rtc_fops = {
> > +static long rtc_fioctl(struct file_operations rtc_fops)
> > +{
> > +     lock_kernel();
> >       .owner          = THIS_MODULE,
>
> You should probably restrict yourself to files that you can at least
> compile ...

Yes of course, I've been silly in didn't verify whether the file compile
but I would appreciate to know whether I'm on the right track or not.

Switching to a different file now...

Thanks.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/

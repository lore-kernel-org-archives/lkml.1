Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbXHUOk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbXHUOk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 10:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbXHUOkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 10:40:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:58403 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbXHUOkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 10:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X5Mpd0UUBEV80pAa7VyfSIpAOxYY2iTIhUDklTVcJT3PiuB1OcrbDFRZnjX4YfV+Pgd8GBaiAJ4f/1aOZwlgtUasQIXGzj2Nwdjluh8RTS67YwMzsSlXsssgJTUhFxsQrBNQUeg0fPQOhL1VXcMxrKVv4SHPBZCdM8L8F6IuhLE=
Message-ID: <52dd17640708210740k2f7e16ccu8b159c513d1d1589@mail.gmail.com>
Date: Tue, 21 Aug 2007 09:40:15 -0500
From: "Guy Streeter" <guy.streeter@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 4096 byte limit to /proc/PID/environ ?
Cc: "James Pearson" <james-p@moving-picture.com>, linux-kernel@vger.kernel.org
In-Reply-To: <46C33700.1060605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4474B7DB.8000304@moving-picture.com>
	 <200605242029.k4OKTn9C031700@terminus.zytor.com>
	 <447EF58C.6000605@moving-picture.com>
	 <52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com>
	 <46C33700.1060605@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Guy Streeter wrote:
> > On 6/1/06, James Pearson <james-p@moving-picture.com> wrote:
> >> H. Peter Anvin wrote:
> >>> I think this is the wrong approach.
> >>>
> >>> Many of these should probably be converted to seq_file, but in the
> >>> particular case of environ, the right approach is to observe the fact
> >>> that reading environ is just like reading /proc/PID/mem, except:
> >>>
> >>>  a. the access restrictions are less strict, and
> >>>  b. there is a range restriction, which needs to be enforced, and
> >>>  c. there is an offset.
> >>>
> >>> Pretty much, take the guts from /proc/PID/mem and generalize it
> >>> slightly, and you have the code that can run either /proc/PID/mem or
> >>> /proc/PID/environ.
> >> The following patch is based on the /proc/PID/mem code appears to work fine.
> >>
> >
> > This thread has gone stale. The PAGE_SIZE limit still exists. Is this
> > solution acceptable?
> >
>
> Can we avoid the code duplication?
>
>

I hope you're not asking me. I don't know the proc fs code well enough
to re-write this.

--Guy

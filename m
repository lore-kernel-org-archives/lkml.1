Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbXIRTnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbXIRTnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbXIRTnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:43:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:9895 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbXIRTm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tWBiosyS44YBY4y7ipyaRxSj3C+mOJbu9vmeS49A26cnRvac2IDjqkSP/F2EYZcG5VgVJOd6glYnSVcGGI1MSa9MNLismMw8nmXX+hT30Zabfg3qQYZGejLQL4SKApDtvVcbqDKpAbznIJ/asD/KH72J/Xz7w+OAF4wY61ZHnjE=
Message-ID: <a44ae5cd0709181242j517e39e0xc3f78224bcda360a@mail.gmail.com>
Date: Tue, 18 Sep 2007 15:42:58 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: 2.6.23-rc6-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <20070918191741.GA27725@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <a44ae5cd0709180827w7156dc17q13853c3f2c127142@mail.gmail.com>
	 <20070918191741.GA27725@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> Hi Miles.
> On Tue, Sep 18, 2007 at 11:27:23AM -0400, Miles Lane wrote:
> > Selecting Help for "Subarchitecture Type" causes "make menuconfig" to
> > crash, and the bash display settings have to be reset.
>
> Not reproduceable here.
> But I noticed that we pass a null pointer to a vsprintf function which
> in the cases you pointed out printed a (null) at my system.
> Could you plase try if attached patch fix your system.

Sorry, it still crashes.  I am running Ubuntu pre-6.10 (Gutsy -- the
development version of the distro).  Maybe I should try "make
mrproper" first?

ncurses 5.6+20070716-1ubuntu1
bash 3.2-0ubuntu9
GNU Make 3.81

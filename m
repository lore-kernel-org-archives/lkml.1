Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbYCZTOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbYCZTOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 15:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbYCZTOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 15:14:22 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:25570 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYCZTOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 15:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e86lGUICDN9zG7xvZr7lxNt4iKTkx7WzaSDU2a/D7T59nxkbFH6SXbq1qUlQeCbNgDYqyVlYMIk7/2zrtHN2h9UmLTjbq+IK/sL6NVZ3WowgIwU3jgpG3bpPi7TxPuhcInO/Eu/WleLzlDWJ7CvfNvrYXX9zRdOUEvBhQkh7V5A=
Message-ID: <8bd0f97a0803261214y3db259edxbb22b8655a5c6693@mail.gmail.com>
Date: Wed, 26 Mar 2008 15:14:14 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 1/1] [Blackfin try #2] char driver for Blackfin on-chip OTP memory
Cc: "Jiri Slaby" <jirislaby@gmail.com>, "Bryan Wu" <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, "Wim Van Sebroeck" <wim@iguana.be>
In-Reply-To: <20080326190917.GB24954@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206580131-22527-1-git-send-email-cooloney@kernel.org>
	 <47EA268F.8070006@gmail.com>
	 <8bd0f97a0803260731x4378c71q1e2e5598c1728e1d@mail.gmail.com>
	 <47EA971B.1020502@gmail.com>
	 <8bd0f97a0803261140w7498b0cfwff38302779f589dc@mail.gmail.com>
	 <20080326190917.GB24954@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 3:09 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>  > >  > also, it isnt "broken" in the sense that it "doesnt work" ;)
>  > >
>  > >  Gcc simply doesn't allow that, you likely got 2 sections with init.data, with
>  > >  and without readonly bit set, which is wrong, and it seems, that on some systems
>  > >  (debian) you won't even compile it.
>  >
>  > gcc-4.1.2/binutils-2.17 doesnt have a problem compiling/linking the
>  > code in question.  and i imagine i would have noticed a build/link
>  > failure long before testing it on actual hardware.
>
>  target arch dependent. Try with 64 bit powerpc.

this code appears in drivers that are for Blackfin-specific pieces of
hardware.  it may fail to build on
some-random-arch-that-isnt-Blackfin, but if it works for Blackfin,
what do the other arches realistically matter ?

yes, the code will get changed as suggested as it is the right thing
to do, it just isnt a real problem today.
-mike

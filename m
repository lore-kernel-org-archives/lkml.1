Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbXKWJBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbXKWJBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 04:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbXKWJBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 04:01:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:51915 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbXKWJBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 04:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bUeIF6jkkU2PgkBAhUulhwAc+d/tVrzjljBDjxpd5D4m+nwWzepAOZBSyD9+up24CqQKhyGJE9Efvz7/b+TRZUh1i2M1D+hGNXfUQnVuDCO74OPSY+f1RIW2m+VVj3pWRTDWmCaOkAgDosw8+B+JHGjUjENyN0TQu7lVYiu73RQ=
Message-ID: <ea9232d10711230101j24e4bd4btce65e62b9fcc8f8b@mail.gmail.com>
Date: Fri, 23 Nov 2007 10:01:21 +0100
From: "Karol Swietlicki" <magotari@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: [uml-devel] uml doesn't work on 2.6.24-rc2
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <20071122235141.GA7876@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu>
	 <20071114011002.GA11477@c2.user-mode-linux.org>
	 <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu>
	 <20071114142247.GA5848@c2.user-mode-linux.org>
	 <E1IsK83-0008CJ-00@dorka.pomaz.szeredi.hu>
	 <20071114173639.GA7899@c2.user-mode-linux.org>
	 <E1IsPo5-0008RU-00@dorka.pomaz.szeredi.hu>
	 <20071116170630.GA9299@c2.user-mode-linux.org>
	 <E1IvGTn-0007cC-7q@dorka.pomaz.szeredi.hu>
	 <20071122235141.GA7876@c2.user-mode-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/11/2007, Jeff Dike <jdike@addtoit.com> wrote:
> On Thu, Nov 22, 2007 at 07:08:47PM +0100, Miklos Szeredi wrote:
> > Thanks.  My other problem is (probably you are aware) that recent -mm
> > kernels don't compile for UML.
>
> The patch below fixes the build for rc3-mm1 for me.
>
>                                 Jeff

There must be something more to it. I got a clean -mm and it still
does not build after applying the patch. It does have less problems,
but it still won't build. I tried to get it to compile for half an
hour, but considering the amount of sleep I got (and my experience),
there is no surprise that I failed miserably. After fixing the
complaint about a structure not having a 'x86' member, it died in the
linker complaining about stuff relating to rwsem.h.

Karol Swietlicki

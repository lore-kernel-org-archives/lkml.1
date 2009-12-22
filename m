Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbZLVHjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbZLVHjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 02:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbZLVHjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 02:39:41 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:56216 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZLVHjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 02:39:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ArchwDrzHPLGSBDcwbMircmO4qvRYv+aTDAl3aadbnBEiwZz+4+LNNNG/KjY2OR/yb
         J3n/fEiIDF9OF/eMChg7atAzA1TUTazn7ldM3Rf8fw61BDkQSiGOdmryPqlOrLJGoYy0
         PehRnBIqtTY8aZAHhWNLDvemhfUElq5x5Buss=
MIME-Version: 1.0
In-Reply-To: <28f2fcbc0912212333yd35f8a8jf0c7087b74fd3582@mail.gmail.com>
References: <1261042383.14314.0.camel@localhost> <1261195412.8240.153.camel@marge.simson.net> 
	<1261244163.14314.62.camel@localhost> <200912200422.18314.andres@anarazel.de> 
	<1261311050.14314.67.camel@localhost> <1261321981.6105.60.camel@marge.simson.net> 
	<1261324276.7227.11.camel@marge.simson.net> <28f2fcbc0912212333yd35f8a8jf0c7087b74fd3582@mail.gmail.com>
From: Jason Garrett-Glaser <darkshikari@gmail.com>
Date: Tue, 22 Dec 2009 02:39:20 -0500
Message-ID: <28f2fcbc0912212339pf3a6e7awe4d8fc7af0054452@mail.gmail.com>
Subject: Re: x264 benchmarks BFS vs CFS
To: Mike Galbraith <efault@gmx.de>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Andres Freund <andres@anarazel.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 2:33 AM, Jason Garrett-Glaser
<darkshikari@gmail.com> wrote:
> Benchmarks for the new threading model are up, along with a few others:
>
> http://doom10.org/index.php?topic=78.0
>
> Interestingly enough, CFS beats BFS on zerolatency by a significant
> margin.  Unsurprisingly, given the threading model, the optimal number
> of threads is equal to the number of cores.
>
> Jason
>

And I am apparently blind: I cannot read graphs.  Ignore the
conclusion made in the above post ;)

Jason

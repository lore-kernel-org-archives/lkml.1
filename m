Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbXFORa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbXFORa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXFORaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:30:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:27297 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXFORaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bTUbWlW+RxTF/vfQ1QNw6MVDGyc6x69C0qN+LBgqhfH76GaMSmaQewA9iqZE9pU/Hoj8Qy18FUosZfJNi+pzMO3zwuijdMfzTwvl5JiPt4zTzK2FUCGC66h3GAqS6I57HPcsemw4Qm7xIBQC6rVI4o7kcli8pvx0Fk76f1pB6gs=
Message-ID: <6934efce0706151030v3357afe6q8073c59610f3b924@mail.gmail.com>
Date: Fri, 15 Jun 2007 10:30:19 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: carsteno@de.ibm.com, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       linux-kernel@vger.kernel.org,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>,
       "Heiko Carstens" <h.carstens@de.ibm.com>
In-Reply-To: <20070615114913.GA30414@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706121711m738bd9abqa02350ccc7eabf9f@mail.gmail.com>
	 <4671495A.3020605@de.ibm.com>
	 <6934efce0706140953x2167944fr54eca6376e1f8d63@mail.gmail.com>
	 <46725A4D.1040404@de.ibm.com>
	 <20070615114913.GA30414@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If you can write code that doesn't need any struct pages that would make
> life a bit easier, since we wouldn't need any pseudo memory hotplug code
> that just adds struct pages.

That was my gut feel too.  However, it seems from Carsten and Jörn
discussion of read/write XIP on Flash (and some new Phase Change)
memories that having the struct pages has a lot of potential benefits.
 Wouldn't it also allow most of the mm routines to remain unchanged.
I just worry that it would be difficult to set apart these non
volitatile pages that can't be written too directly.

> We would still need to add the kernel mapping though.

But that's handled by ioremap()ing it right?

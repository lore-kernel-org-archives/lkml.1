Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbYHUOmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbYHUOmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbYHUOml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:42:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:63163 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYHUOmk (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=It5Q+G6/R3OFclWJPguloZQBHH4bBySXegJ7Elx0DvzuGe3cZy85978//7gU+1+0Wv
         BY5X5TJ9V26v9gyQ5jNUONIFlqC9vWgifJd+uRiSW8DxIvjNeJ2SUYGfPZHdBoHC6zmI
         /nYRhq3+fjXDb8jaRJdEQc/TTQyyT4S3KbAYg=
Message-ID: <6934efce0808210742v14a093e8vde31f9eea0555f99@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:42:39 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <c384c5ea0808210731k17ccc836u60c4803c3abfea31@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <20080821083916.GF5706@disturbed>
	 <6934efce0808210719s6458dc77w2c0755a4bf90bf8a@mail.gmail.com>
	 <c384c5ea0808210731k17ccc836u60c4803c3abfea31@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What if the use-case did not cover all cases of XIP use?
>
> If a compressed page is attempted to be executed, will the filesystem
> fall back to decompression to RAM and execution from RAM, or will this
> result in a faulty system?

No this will not result in a faulty system.  It is perfectly
acceptable to have all pages in a file XIP, no pages in a fill XIP,
and anywhere in between.

> The design choices look real good. Congrats on the achievement.

thanks!

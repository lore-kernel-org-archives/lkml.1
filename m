Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532Ab0AGNof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0AGNof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365Ab0AGNoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:44:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:25076 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab0AGNod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:44:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d6QxPWj3kPMWnHsq2X1aa7dSiRqauMAlxqJeUb2ei1Yx/TrCX2z4ZPXseFuEgXhTYU
         BF0U5mjtnarKPCoLGBPVRw0O69nIZf9QFH7MiTg7+P3hStCgoOIm9ta5w+4umrbJaw6q
         qEg1nXfTH9CBGj/rzrR/ep5cQeVWAzVqyiZ1I=
MIME-Version: 1.0
In-Reply-To: <x493a2k8d7x.fsf@segfault.boston.devel.redhat.com>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	 <4e5e476b0912250216n2b4aceacyf22a0e73425efd3a@mail.gmail.com>
	 <20091228020348.GB28115@sli10-desk.sh.intel.com>
	 <4e5e476b0912280036r6e55587dj66952fcd6ff4d08b@mail.gmail.com>
	 <20091228084659.GA31389@sli10-desk.sh.intel.com>
	 <4e5e476b0912280111s6a977251m3416341b4bd2c272@mail.gmail.com>
	 <20091228092844.GA9710@sli10-desk.sh.intel.com>
	 <x493a2k8d7x.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 7 Jan 2010 14:44:32 +0100
Message-ID: <4e5e476b1001070544w88a387dkfb48847f4f95a9b1@mail.gmail.com>
Subject: Re: [PATCH]cfq-iosched: don't take requests with long distence as 
	close
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 10:16 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>
> For now, I'm leaning towards asking Jens to revert this.  It may still
> be worth making sure that we don't merge a seeky queue with a non-seeky
> queue.  I have a patch for that if folks are interested.
Jeff, can you send this patch to Yanmin, that is investigating a
regression apparently caused by excessive queue merge?

http://lkml.org/lkml/2010/1/4/194

Cheers,
Corrado

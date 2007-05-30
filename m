Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbXE3Occ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbXE3Occ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXE3ObB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:31:01 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:53647 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbXE3Oa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:30:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: kexec and aacraid broken
Date: Wed, 30 May 2007 10:30:56 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55010@otce2k301.adaptec.com>
In-reply-to: <20070530141723.GB3773@in.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kexec and aacraid broken
Thread-Index: AceixUkFx9b76PWqQ52cGmijDMeweQAACOTA
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: <vgoyal@in.ibm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal [mailto:vgoyal@in.ibm.com] writes:
> So most likely if we start disabling the interrupts
> in .shutdown routine we might skip resetting adapter
> on every kexec without any side affects?

Not that simple. The .shutdown would need to perform more resource
cleanups of the .remove call to prevent side effects. I need to move
some of the .remove activity into the .shutdown handler to make sure the
adapter is quiesced.

I will hold off on submitting any of these changes until they are
evaluated and tested; I am waiting for feedback from Yinghai on the
other mitigations that I feel are closer to the root cause.

Sincerely -- Mark Salyzyn

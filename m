Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYGIUlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYGIUlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYGIUlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:41:04 -0400
Received: from gw.goop.org ([64.81.55.164]:53295 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbYGIUlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:41:03 -0400
Message-ID: <4875224F.1080702@goop.org>
Date: Wed, 09 Jul 2008 13:40:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies
References: <patchbomb.1215554782@localhost> <200807092202.27013.rjw@sisk.pl> <20080709200428.GB14009@elte.hu> <200807092217.53222.rjw@sisk.pl> <20080709202345.GG14009@elte.hu>
In-Reply-To: <20080709202345.GG14009@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ok, i've reverted this from tip/master now, until you and Jeremy work 
> out the details. (it shouldnt be a big limitation on xen64 anyway)
>   

Yes, that's fine.  It just means you lose Xen save restore unless you 
also have SUSPEND or HIBERNATE enabled, which is OK.  I only found it 
because I'm currently using an allnoconfig config with just enough to 
make Xen work turned on.


    J

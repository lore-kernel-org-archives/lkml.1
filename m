Return-Path: <linux-kernel-owner+w=401wt.eu-S1763886AbYEVVP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763886AbYEVVP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763417AbYEVVOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:14:51 -0400
Received: from www.tglx.de ([62.245.132.106]:50708 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763374AbYEVVOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:14:50 -0400
Date: Thu, 22 May 2008 23:14:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Wessel <jason.wessel@windriver.com>
cc: Alexander Beregalov <a.beregalov@gmail.com>,
       kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: kgdb test suite failure
In-Reply-To: <48344D5B.1020308@windriver.com>
Message-ID: <alpine.LFD.1.10.0805222304250.3295@apollo.tec.linutronix.de>
References: <a4423d670805090714iaae7d4fj2883889ede15a4be@mail.gmail.com>  <4832EBCF.2000407@windriver.com> <a4423d670805201130l649440acl3ef31f60503b279d@mail.gmail.com> <48344D5B.1020308@windriver.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Jason Wessel wrote:
> An RFC type patch follows which addresses the problem, but in my
> opinion not in a terribly clean way...  Perhaps other folks will
> comment on a different or better way to approach the problem or chime
> in on if it should be fixed at all.  Certainly the test suite could be
> changed to use HW breakpoints for the case where the text segments are
> going to be read only as an example.

Please use HW breakpoints in the test suite. The RFC patch looks
horrible :)

Thanks,
	tglx

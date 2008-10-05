Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYJEK26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYJEK26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYJEK2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:28:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40498 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbYJEK2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:28:49 -0400
Date: Sun, 5 Oct 2008 12:28:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional
	hotplug CPUs to be set at compile time
Message-ID: <20081005102835.GA8947@elte.hu>
References: <20081001191945.4182d0be@redhat.com> <87bpy3pdgs.fsf@basil.nowhere.org> <20081002152521.16c4835b@redhat.com> <20081002194409.GB8318@one.firstfloor.org> <20081002160907.68d79e0b@redhat.com> <20081002204018.GD8318@one.firstfloor.org> <87ljx4nw09.fsf_-_@basil.nowhere.org> <20081004183014.769836ff@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004183014.769836ff@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chuck Ebbert <cebbert@redhat.com> wrote:

> Yes, it works and I don't see how it could cause any problems.
> 
> Ingo, can we get this in 2.6.27? You can drop my original patch.
> 
> Tested-by: Chuck Ebbert <cebbert@redhat.com>

looks good, applied to tip/x86/core, thanks!

it's too late for v2.6.27 (and not a serious regression anyway), but i 
marked it for .27.1 backporting.

Your other patch still makes sense - as additional_cpus is an existing 
boot parameter it can be specified at .config time as well. You should 
not enable it in a distro kernel though, if you intend to support real 
hotplug CPU hardware. (which is extremely rare btw.)

	Ingo

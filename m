Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbYKZUPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbYKZUPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYKZUPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:15:10 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:50663 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYKZUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:15:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RP2RVtFXNj5bETQgm+7TMMskLL78ViBD+Z1Cn9GEjFYRniXxU8MqA28NKBzzmjk2Hs
         x2Qzjejg5i1n2NNu1/DpBfvFpzXzrNhZMlESiZmhrmxXfYJkyviyv7TSyH5sBibRM3v7
         3VRrm9GKnDqgWO+BariTxFo11R/xnqO3cOBi8=
Date: Wed, 26 Nov 2008 23:15:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: Re: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
Message-ID: <20081126201505.GC2624@localhost>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <874p1u45ke.fsf@basil.nowhere.org> <20081126201054.GB2624@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126201054.GB2624@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Wed, Nov 26, 2008 at 11:10:54PM +0300]
...
| | 
| | The uncommon path is supposed to be out of line. I don't think
| | the CPU will like that.
| | 
| | -Andi
| | 
| | >  rff_action:
| | 
| | -- 
| | ak@linux.intel.com
| | 
| 
| Aha! Thanks Andi for review.
| 
| 		- Cyrill -

And if I would be tracing all and everywhere would it be
common then? :)

		- Cyrill -

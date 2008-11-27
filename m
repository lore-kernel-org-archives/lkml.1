Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbYK0QVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbYK0QVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYK0QU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:20:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:19271 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbYK0QU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:20:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AHL3dqPlVXWm97dFIVYJ3y7gUbWdD2lzb5ShghYs5/jMAkCKqw92F/1hcThphaUP2K
         s3KTEE7pVq0qLtFcbm5EDLs8sQ9FdvG6dqv6j1Cd0mqNu1lxdEM93Fvz5weZRkdCMA9F
         A83m4qNSRCOsSZ1KmEz49hEZHyZeNwp8ItgBk=
Date: Thu, 27 Nov 2008 19:20:52 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: Re: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
Message-ID: <20081127162052.GA23593@localhost>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <874p1u45ke.fsf@basil.nowhere.org> <20081126201054.GB2624@localhost> <20081127134121.GA22736@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127134121.GA22736@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Thu, Nov 27, 2008 at 02:41:21PM +0100]
...
| 
| Could you test something like the patch attached below, which cleans 
| up this code and applies the code reduction and speedup? Warning: 
| completely untested! Please check that things like strace -f and gdb 
| attaching to forked tasks still works fine. (it should by all means)
|
...

Thanks for explanation Ingo! Will try to test this but I will require
some time.

		- Cyrill -

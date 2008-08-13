Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYHMQFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYHMQFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYHMQFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:05:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:19779 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYHMQFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SIyylueEsqbmxThqGBbMS+FLOhjIlIggUBOTHEsabXaRO9Iz0g0ftezWmbuq5BtkIA
         HwYGfaW3FfsL+bH9pCtxzHfVf1j/xVxm12lbR1X32VpJfG0DeAGKVup+8gi8zwC+jMTU
         4QqFOF+/s58Ey/lDt3/JUaBl1ehD98M0vFydQ=
Message-ID: <86802c440808130905s360c9695jef64b6ed7746899@mail.gmail.com>
Date: Wed, 13 Aug 2008 09:05:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- experimental revert for 2.6.27 failed
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <108777.49875.qm@web82104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <108777.49875.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 5:03 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> please try attached patch with 2.6.27-rc3
>
> Thx for the patch... and for providing it as an attachment.  My email
> situation is less than optimal, and I am stuck using my ISP's web
> interface for the present.
>
> I used 'git apply --check <patchfilename>' first, and got no errors, so
> I applied it, built, installed, and rebooted.

could apply with
cat revert_*.;patch | patch -p1

YH

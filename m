Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbYIHQZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbYIHQZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYIHQZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:25:42 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:14724 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYIHQZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:25:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I6oTvta2/dmwQUIyFab1qnH2Vcu6VWQEKMFcYAZS135P8izKySKNaeIV+zdame0WIn
         pTvKoj5diZ8dLtW7L11a6+6CMJlp7PtboKVbAztJRyk8P5R8Dk+QepNamjBLJu4CznqU
         lzktpG08KkSXpy84oxNR3Rr9B302Vth9jtjNI=
Message-ID: <8ee0b8e80809080925h47470253hc124ea54d239c931@mail.gmail.com>
Date: Mon, 8 Sep 2008 18:25:39 +0200
From: "Jeroen van Rijn" <jvrnix@gmail.com>
To: "Tony Vroon" <tony@vroon.org>
Subject: Re: Request for MCE decode (AMD Barcelona, fam 10h)
Cc: "Andi Kleen" <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1220889138.27320.53.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220754742.8530.12.camel@localhost>
	 <87abeivrdf.fsf@basil.nowhere.org>
	 <1220876559.27320.2.camel@localhost>
	 <20080908140417.GJ26079@one.firstfloor.org>
	 <1220889138.27320.53.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 5:52 PM, Tony Vroon <tony@vroon.org> wrote:
> On Mon, 2008-09-08 at 16:04 +0200, Andi Kleen wrote:
>> Ok so you wanted linux-kernel to diagnose your hardware for you?
>
> I was hoping for some help in narrowing it down, yes. Jeroen's reply was
> very helpful, and more among the line of what I was expecting. I have
> contacted all vendors involved now, and it looks like the system RAM is
> not fully compatible with the mainboard.

I'm happy to see you've got it narrowed down enough.

> With regard to the message, I would suggest an alternate wording like
> such:
>
> A hardware component in your system is failing.
> Please contact your hardware vendor(s).
> If unsure, contact your CPU vendor first.

Or this:
"A hardware component in your system is failing.
[insert specific bit if MCE is certain enough about what part]
If you can, try to narrow it down by placing it in another mainboard
(assuming you have one available), or run [memcheck, another tool].
Then contact the hardware vendor(s) in question, if uncertain, try
your CPU vendor first."

> Regards,
> Tony V.

Jeroen.

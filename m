Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbYLHLOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbYLHLOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYLHLOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:14:24 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:12082 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYLHLOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xBpmG4jVbo+EPID38xGbwTtVcBEMHufc71deUK9Pnj0Nrhq2XHHQnQuuThrX2lIf7a
         3/14ZLC27vlSt7CAwWrI3oROU+IFbww5Z3WHT15YMZuixxeqHSWf8VSyK7NsOPM/bl/4
         pSlaJlGH5c/n6EdNtegALXXkT2KMeQG+Fa8DU=
Message-ID: <12bfabe40812080314s4b3c622dqd6262c863ea48798@mail.gmail.com>
Date: Mon, 8 Dec 2008 12:14:22 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       "Andi Kleen" <ak@linux.intel.com>
In-Reply-To: <493CFD7E.4060407@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493B4242.1040202@shaw.ca>
	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
	 <20081207141337.588aede5@infradead.org>
	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
	 <493CCFE4.2080802@jp.fujitsu.com>
	 <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
	 <493CEAA0.50201@jp.fujitsu.com>
	 <12bfabe40812080226h13b8d52bia39cc20b404ba910@mail.gmail.com>
	 <493CFD7E.4060407@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/08, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> Giangiacomo Mariotti wrote:
>> I tried "mce=nobootlog" and the mce log seems to have disappeared :
>
> Good.  It means the error was before the previous reset.
>
>> Now that you mention it, I always shut down the system from Linux,
>> because reboot doesn't work(from windows vista 32bit it works). If I
>> reboot the system from Linux it goes down, but then it enters a cycle
>> of automatic power down power up(with a beep) and it never stops until
>> I switch off the power supply.
>
> Wow... I suppose you had to report & solve it first.
>
> Thanks,
> H.Seto
>
I guess you're right, but I just guessed it was a bios related
problem, where Linux does the right but wrong thing while windows does
the wrong but right thing, so I thought it would have been a bigger
problem trying to solve it, than simply use an -h instead of an -r.
Anyway, if people actually think this might be useful, I may file a
bug at bugzilla, or I can simply continue this thread if anyone has
something to make me test or any other request to help tracking down
this problem.

Thanks,
Giangiacomo

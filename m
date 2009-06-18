Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZFRTeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZFRTeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZFRTdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:33:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43065 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZFRTdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:33:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oMg4pdwXgdaOowp1wEJxDJsvi+Ayp9d4jCmhVQ4MlE7+ubChUAfNEYEOraPIbUHcd
	XwWhgsSOdbNx1fNQ8HHgQ==
MIME-Version: 1.0
In-Reply-To: <20090618101309.GC28892@elf.ucw.cz>
References: <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com>
	 <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com>
	 <20090612150504.GA15084@elf.ucw.cz>
	 <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
	 <20090615170103.GE25040@elf.ucw.cz>
	 <a55d774e0906151132m5584409epe0b7581fde5ec184@mail.gmail.com>
	 <20090617091139.GA4536@elf.ucw.cz>
	 <a55d774e0906170240w631cdfbfq52647d1c438647cb@mail.gmail.com>
	 <d6200be20906171436y5280ed8do561d2d53d73ca78@mail.gmail.com>
	 <20090618101309.GC28892@elf.ucw.cz>
Date: Thu, 18 Jun 2009 12:33:48 -0700
Message-ID: <a55d774e0906181233p35b60cd2ga401bd1304267643@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Arve Hj?nnev?g" <arve@android.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 3:13 AM, Pavel Machek<pavel@ucw.cz> wrote:
>>
>> I used setkey on older hardware to get a usable console, but the
>> original dream keyboards did not need a special keymap to be useful.
>> We change the keymap in vendor/htc/dream/init.trout.rc, but it is
>> probably the opposite of what you want.
>
> Ok, I created something useful in the meantime. Question is, what to
> do with the new keymap? I can obviously keep it at local patch, but...
>
> PC defkeymap.map makes HTC Dream useless.
>
> HTC Dream defkeymap.map makes PC useless :-(.

Yeah, I wasn't sure how to handle this.  We try to keep the msm/dream
stuff in a state that doesn't break other parts of the tree, but there
doesn't seem to be support for different keymaps for different
devices.

Brian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0CIIqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:46:36 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:50999 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0CIIqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:46:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hM5AaWlehKeU6+sNh7AKJayRSZUi7cUPYTg5/V1TxeoHW9b9xToYU9mX9Y3Bokuq4g
         68du0iVsc5zvwXwCNbEunsgDB6lScLXjAb+6BsftSYFVpVBcLDzbWtq1iFvAC7M8WFpR
         ZEeLVhQeYlcPtNVh8s/+W0CY14qISDVbizWaw=
MIME-Version: 1.0
In-Reply-To: <20100309072938.GA6137@elte.hu>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	 <20100308094647.GA14268@elte.hu>
	 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	 <20100308190857.400bde09@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1003081115280.3989@localhost.localdomain>
	 <20100308192744.5f40a5ee@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1003081132370.3989@localhost.localdomain>
	 <20100309072938.GA6137@elte.hu>
Date: Tue, 9 Mar 2010 18:46:33 +1000
Message-ID: <21d7e9971003090046n7da34978n36b1745184f412a@mail.gmail.com>
Subject: Re: Upstream first policy
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 5:29 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Mon, 8 Mar 2010, Alan Cox wrote:
>> >
>> > man restorecond
>>
>> I know. I also sometimes sit through minutes of "let's relabel the system,
>> because you've booted a kernel without selinux support".
>
> I've had selinux relabeling wait times of an hour or two too, on a
> sufficiently large filesystem.
>
> I think this hurts security far more than anything else, because it causes
> people to actually _turn off the whole thing_ - so we will have less and less
> security in the end.
>
> ( To use the obligatory fire door analogy: we should prefer a one inch thick
>  fire door that opens and closes fully automated to a five inches thick fire
>  door that people keep always-open with a chair. )

selinux relabels are the new fsck.

maybe we need selinux3 or chunk-selinux.

Dave.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZCJLxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZCJLxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZCJLxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:53:08 -0400
Received: from mail-gx0-f167.google.com ([209.85.217.167]:54862 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZCJLxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VfbrVgxmfpCazyymMlJB/y1xnJX0gCapIm0tzYCaiVLPEF9WpJEm6yIUXFjVee3rPj
         OqJd7qbeVEn1GTghU5fnXA2YVzGicLXNOFnY2fi6pFCPJQ5ykDMHTxsA1Pxjd5QecsKO
         InjNC5mZBFS/F3yRZpMtXlzxOwIlKehzer2E4=
MIME-Version: 1.0
In-Reply-To: <1236685698.5183.86.camel@dy>
References: <1236670166-3910-1-git-send-email-graff.yang@gmail.com>
	 <8bd0f97a0903100103w6fc3dfc8se6076c98dbe5d8b4@mail.gmail.com>
	 <7d86d44a0903100425y2ed41d72p3ec43021f554af96@mail.gmail.com>
	 <1236685698.5183.86.camel@dy>
Date: Tue, 10 Mar 2009 07:53:03 -0400
Message-ID: <8bd0f97a0903100453k39bd5e40i965c75c317634673@mail.gmail.com>
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
From: Mike Frysinger <vapier.adi@gmail.com>
To: gyang <graf.yang@analog.com>
Cc: graff yang <graff.yang@gmail.com>, samuel@sortiz.org,
       irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       cooloney@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 07:48, gyang wrote:
> On Tue, 2009-03-10 at 19:25 +0800, graff yang wrote:
>> On Tue, Mar 10, 2009 at 4:03 PM, Mike Frysinger wrote:
>>> On Tue, Mar 10, 2009 at 03:29,  <graff.yang@gmail.com> wrote:
>>>> +               do {
>>>> +                       lsr = SIR_UART_GET_LSR(port);
>>>> +               } while (!(lsr & TEMT));
>>
>>
>>> i'm pretty sure we determined that it is not the job of the
>>> kernel to
>>> make sure the line is clear before we go changing speeds.
>
> But we should prevent changing speed when the byte is sending out.

no we shouldnt.  if the user changes speeds while things are being
transmitted, then they screwed up.  this is why tcdrain/tcflush exist
on the tty side of things.
-mike

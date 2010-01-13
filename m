Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527Ab0AMCJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab0AMCJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 21:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326Ab0AMCJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 21:09:05 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:53966 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab0AMCJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 21:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xm3MDhPld4a3eNyyA+5jRxCvTDQm5cQYmJVH+OYiyP0OjiZ/6KOvniFoJJg4NAt9/1
         uzeP9sgehtsEnL/VoMMbZ3apbLjn+dKD3tfMuebB/ppgiHH1AEWYBnbXtOJTtROs3ZqH
         At54De5x1uLeZmivyn8EYKSyBDQMe/AKKn5wI=
MIME-Version: 1.0
In-Reply-To: <20100112162823.GC7363@basil.fritz.box>
References: <20100110020955.GB25323@basil.fritz.box>
	 <20100110063335.GA3005@hack> <20100110123702.GC25323@basil.fritz.box>
	 <20100112153208.GF3925@hack> <20100112162823.GC7363@basil.fritz.box>
Date: Wed, 13 Jan 2010 10:08:59 +0800
Message-ID: <2375c9f91001121808y7c4cbe3es802f5ddd433b7bc3@mail.gmail.com>
Subject: Re: 2.6.33 pagemap endless read loop
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 12:28 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> Hmm, could you please try:
>>
>>      time cat /proc/self/pagemap >/dev/null
>>
>
> I stopped it after a minute of CPU time...
>
> Obviously reading 47bits of zeroes take a long time.
>

Yeah, but this just proves it is not endless, doesn't it? :)

Thanks.

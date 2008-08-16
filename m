Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYHPXbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYHPXbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 19:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYHPXbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 19:31:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:29300 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbYHPXbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bpRgAFJ1v2JiQTKVigX0Ys1MjdI5M5lKGWstfbmbUL9qiZ19zG7FAygDwhHmUwPn68
         09ywIkMYzpYmHn3Kv2qRBjH39BclHZDS1HRz/glHubcLGb0bmk00hJ/V049El237VVRY
         9aANWgHrjqC1hH0yZZ+XteJzh5mJbbrxNgZLc=
Message-ID: <82e4877d0808161631t40fcc9d4r99de0e4ddaee2f5a@mail.gmail.com>
Date: Sat, 16 Aug 2008 19:31:36 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] Add Dell laptop driver
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080816232336.GA6992@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0808161617k5404f4ectf6d502de5b7fea4c@mail.gmail.com>
	 <20080816232336.GA6992@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 7:23 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sat, Aug 16, 2008 at 07:17:05PM -0400, Parag Warudkar wrote:
>> > +   da_tokens = krealloc(da_tokens, (da_num_tokens + tokens) *
>> > +                        sizeof(struct calling_interface_token),
>> > +                        GFP_KERNEL);
>>
>> Isn't a NULL check required here?
>
> To the extent that it would result in this failing gracefully before
> some other part of the kernel becomes hideously upset, sure. I have a
> hard time caring, but I can easily fix it if other people do :)

Yeah, it's a RFKill switch after all, not a LaptopKill switch :)

Seriously though a quick search through LXR results for kzalloc shows
that most everyone does care.
And if I find ones that don't  a patch will follow soon.

Thanks

Parag

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZGOUM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZGOUM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZGOUM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:12:58 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36512 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbZGOUM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aX7VehL920RqN/OHQzRCLUTL2xExNozD3TAgF2SD6aRxOWRXj+AKWcWfbO5oddxtsh
         45eBrVCMdJelfust33qNCyBGk/hj74dxSMUYhZo26/rV86EQwoYmruZ/DbDe3/HZAdq5
         AZFXIp8iC2zK9T53p85362nleUS0b6gjTLxwk=
MIME-Version: 1.0
In-Reply-To: <4A5E2944.2070904@suse.cz>
References: <20090526152540.GA28341@sepie.suse.cz>
	 <20090703144547.GA20980@sepie.suse.cz>
	 <1247675954.3968.140.camel@quest>
	 <ac3eb2510907150946y461fee0dj6e8f5265b4f91215@mail.gmail.com>
	 <cc43514a0907151104r6208a3dbm89dba496c1411fc0@mail.gmail.com>
	 <4A5E2944.2070904@suse.cz>
Date: Wed, 15 Jul 2009 22:12:55 +0200
Message-ID: <cc43514a0907151312l34bc6c92m7986fd1f99cfca2c@mail.gmail.com>
Subject: Re: [PATCH] kbuild: generate modules.builtin
From: Andreas Robinson <andr345@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Scott James Remnant <scott@ubuntu.com>,
       linux-modules@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 9:08 PM, Michal Marek<mmarek@suse.cz> wrote:
> Andreas Robinson napsal(a):
>> Guys,
>>
>> is this patch what you need on the m-i-t end?
>
> I already have patches here (it's not against Jon's master, but it
> should apply):
> http://repo.or.cz/w/mit.git?a=commit;h=45c29de1b54478a63352a3f13c570a964903f54f
> http://repo.or.cz/w/mit.git?a=commit;h=0e72912a1e0b486225f7052c8d40e28b07ff4495

Ah, of course!

> The idea is that modprobe should just do nothing and exit successfully,
> so that scripts don't break nor start printing warnings if the kernel
> config changes. I meant to send it to linux-modules once there is
> agreement about the modules.builtin file format.

Ok, that makes sense.

I think there's a small chance of confusion though, when a user tries
to insert a module and it doesn't show up with lsmod. Perhaps you can
add an info() message? Then the user can figure out what is happening
with the --verbose option.

Andreas

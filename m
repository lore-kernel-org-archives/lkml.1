Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbZJCWFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbZJCWFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 18:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZJCWFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 18:05:03 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:54098 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZJCWFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 18:05:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XNB/wOttOqbVof0p1eA+isUcJNlQZVh1LAz8yHEnQZ+2v6xJHzJDpnA/9sepe5LDdZ
         NfF0xL0e3UBQcvu7RujduQ5RwpvW6vlJIDsbcJmiXFMPPI/DUjO4kJD8rSmb2Wrg4nsj
         9LKqRGTRfQp/VS3jVZnVMuGX6MnJlwhnM7FS4=
MIME-Version: 1.0
In-Reply-To: <20091003110546.78958508@infradead.org>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 
	<20091003110546.78958508@infradead.org>
From: Matteo Croce <technoboy85@gmail.com>
Date: Sun, 4 Oct 2009 00:04:03 +0200
Message-ID: <40101cc30910031504pa9f8536k82dbd7668dfa643d@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Arjan van de Ven <arjan@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 8:05 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sat, 3 Oct 2009 04:12:47 +0200
> Matteo Croce <technoboy85@gmail.com> wrote:
>>
>> I also did this simple test which gives a ~2.5x speed boost:
>> http://pastebin.ca/1590089
>
> the number that is exposed in /proc/cpuinfo does not control
> if cmov is used... so the patch and the benchmark are totally unrelated.
>
> Anything that needs to know if cmov can be used will need to read the
> flags line..
>
> (since technically cmov is also optional for generation 6 and later)
>
> While I can't say anything against your patch, I do need to say that it
> is something purely cosmetic on first sight...
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>

yes cmov and i686 are unrelated but some distros (Debian & co.)
compiles libraries for two archs:
i486 and i686-cmov so only i686 machines does benefit from cmov.
This is why I cared about having an i686 aware userspace but it seems
that for a missing instruction I can't do that

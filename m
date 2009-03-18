Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbZCROWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbZCROWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 10:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZCROW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 10:22:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:46937 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103AbZCROW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RgqHJd/6YulfRbMtafqqUt5CXMlXVW/Xmh1kmZLeyie7ZRSK0y7n5BYGUFC0gRZo1Z
         7LlQOEHQHrrOdjoCZmFVYGY5B2oZVHMWOpTy4fczQx0fK7xMOgiUXsCsfDSwrGfgzTY9
         55GWfXQVKGaQKikVHfX6FFeFpeO/kV3aGmeTE=
MIME-Version: 1.0
In-Reply-To: <84144f020903170940nf76d905t43bfa497bd5fe6d5@mail.gmail.com>
References: <e9e614960903162141g2f272f82jee434fc6fc748544@mail.gmail.com>
	 <84144f020903162307x3d164432m4132b0dd1487bae@mail.gmail.com>
	 <20090317090322.GA24133@elf.ucw.cz>
	 <e9e614960903170543p6117ce22qd0773d5a7cdd9977@mail.gmail.com>
	 <84144f020903170940nf76d905t43bfa497bd5fe6d5@mail.gmail.com>
Date: Wed, 18 Mar 2009 22:22:23 +0800
Message-ID: <e9e614960903180722h49f3719fp3a947fd194066233@mail.gmail.com>
Subject: Re: w35und driver unusable
From: luoyi <luoyi.ly@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just rmmod and modprobe it will trigger the oops.

I've just upload a oops snapshot picture onto flickr:

http://www.flickr.com/photos/21260339@N03/3364812089/

hope it will help for you.

2009/3/18 Pekka Enberg <penberg@cs.helsinki.fi>:
> Hi!
>
> (off-list)
>
> On Tue, Mar 17, 2009 at 5:43 AM, luoyi <luoyi.ly@gmail.com> wrote:
>> Wow,  thanks for your advice. and I can get it work now after I set my
>> wireless AP's channel to 1 and mode to "b/g auto".
>>
>> 3 problems:
>>
>> 1. it can only work with 802.11b mode
>>
>> 2. rmmod w35und
>>   modprobe w35und
>>   Kernel Panic
>>
>> 3. after it get IP address with dhcpcd, if I execute iwlist scan, then
>> it will lose the connection and never restore again, the only way make
>> it work again is to restart my computer.
>
> Just to let you know, I am traveling right now and dont have my laptop
> with me. I wont be able to look at the issues until next week but
> please do post the oops as requested in the other email so other
> people can take a look at it meanwhile.
>

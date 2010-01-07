Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803Ab0AGTWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0AGTWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377Ab0AGTWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:22:16 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:63814 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab0AGTWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:22:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wbpKXrXHpniwsNkMAJSl/QT6nQSMYdiWyrFa8dR6A3iD0ZBxUK8kfunLhi24nK05NH
         RsmdDPdcC/R4B7EY9xWLbOthKcti5PdF/TWd6S/2J++z7Ful9Bhw6G1vDADPZKGE60G+
         QqW2YZo686vyXICmYc9FjlpaJ8+t6/JskZBfk=
Message-ID: <4B463484.7060703@gmail.com>
Date: Thu, 07 Jan 2010 11:22:44 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] sys_paccept: disable paccept() causes my macbook	pro
 to  have an annoying whining sound
References: <dd18b0c31001062216m316163f4t992c000eca0f76d@mail.gmail.com> <873a2ixmwy.fsf@basil.nowhere.org> <4B460132.3010706@gmail.com> <20100107160246.GB16076@basil.fritz.box>
In-Reply-To: <20100107160246.GB16076@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/10 08:02, Andi Kleen wrote:

o.k. so using the boot param
with the latest kernel takes care
of the noise.

Now as a test I did
git reset --hard origin 2d4c8266
to where the bisect was pointing too.
then once booting the noise was there.
Then reverting that commit, caused the system
to be noiseless..

My guess since this might be power related
it could be anything(sys_paccept hit it just right)
i.g. whatever sys_paccept does(when turned on)
generates enough wakeups(if this is correct term),
to keep the system from generating this noise at the certain
C level or however/whatever it's doing.

At this point I'm not sure what to really do.
if using the boot param(max_cstate) is a safe option
then I'll just use that and/or look at paccept/accept4 to see
what really generates enough wakeups or keeps the processor
at a level to keep the noise from generating.


Justin P. Mattock

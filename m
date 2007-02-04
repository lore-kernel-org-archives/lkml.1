Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbXBDW46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbXBDW46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 17:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXBDW45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 17:56:57 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:57419 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbXBDW44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 17:56:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gxIt+cRoSqyJ3a8mnnQ9VNP+0m+vXWyhCRv7HWNZkyPKZq1hA9KNwpqn3kLAb/J3XUivb72CiobjZ+NO9p9ssnE803asH1kxtlQ0on5vupP1VscmHx4OOmT7oZNqA8qyJIElJ0bmXXsul9+klKTwZ4dcm893jakje9wcGsSOIJg=
Message-ID: <82e4877d0702041456u5d30d32bs41233048a1833d59@mail.gmail.com>
Date: Sun, 4 Feb 2007 17:56:55 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: netdev@vger.kernel.org
Subject: Re: Unexpected Acknowledgement / Stalled Connections
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <82e4877d0702041431p555e644et35845db674304403@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0702041431p555e644et35845db674304403@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Parag Warudkar <parag.warudkar@gmail.com> wrote:
> I am running 2.6.20 and have trouble with stalled connections. For
> instance, if I try to download a debian ISO image using wget, the
> connection runs fine for few seconds and then stalls for ever.
>
> In my router logs I see a ton of messages like the below -
>
> [INFO] Sun Feb 04 17:22:03 2007 Blocked incoming TCP packet from
> 192.168.0.174:34090 to 130.239.18.138:80 with unexpected
> acknowledgement 3269301836 (expected 3269343453 to 3269408989)
>
> Where 192.168.0.174 is my laptop running FC6 and kernel 2.6.20 and
> 130.239.18.138 is whatever cdimage.debian.org resolves to atm.
>
> What's going on here? Any TCP/IP tunable that I can set/turn on/off to
> prevent this from happening?

Turning tcp_sack off seems to cure it. Turning it on again makes the
connections stall. Seems like the D-Link router doesn't like the SACKs
linux sends?

Parag

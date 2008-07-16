Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbYGPMbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbYGPMbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYGPMay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:30:54 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:60004 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbYGPMax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ai1YaYwv6kB8kTJJ6kQ3D/CYtDLX+mNxl929EblJ6NbW4Tlv454dxjYnFL/B72m5TU
         iY4rS0V29nKhkPILdbXjSIGq5gDgBSRkakwiJov12kt/arhcQL222J9Hh3VMeMWUxYl7
         27wIT1/2AJwjfCDUOFWxRCFadqWd6R6OLiZbQ=
Message-ID: <520f0cf10807160530g1a9c3a09w2fd4237199612fd7@mail.gmail.com>
Date: Wed, 16 Jul 2008 14:30:52 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: Make the git URL match usage
Cc: "Andy Whitcroft" <apw@shadowen.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0807161338290.26724@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807161047.21040.jkacur@gmail.com>
	 <20080716102104.GA7477@shadowen.org>
	 <520f0cf10807160334y7228527ev7e970b00c734778d@mail.gmail.com>
	 <alpine.LNX.1.10.0807161338290.26724@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 1:43 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Wednesday 2008-07-16 12:34, John Kacur wrote:
>>>
>>> This now looses information.  Although it is obvious that this particular
>>> example (after conversion) is a git repository over git protocol this falls
>>> down for other forms, for example a git repository exported over http://
> [...]
>
> git over http really is no fun at the moment and one should really
> use git:// whenever possible. Where it is not possible due to
> tightknotted corporate firewalls, well, that's (a) their problem and
> (b) they probably know already how to go around it.
>
> If in doubt, just add a paragraph that one can exchange git://
> by http://, but I would not make it that obvious to use an inferior
> transfer protocol.
>

Luckily I didn't see any use of http:// with git listed in the MAINTAINERS file.

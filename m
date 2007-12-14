Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbXLNOMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbXLNOMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXLNOMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:12:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:46834 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbXLNOMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:12:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=W/B/kJAt7X0oU+hWdo83xQ/vC/lYmXJOIFIO1pyonkp7MaxkqsBlVxkJGF/S4QlGBT8cp/bcFIa73yJoguP5z0roT8t1qJqKwr3HAHOHxCVZKdSt+V2hJYU4nqqsWcqeQrovFJjDTtcNSR1XJLaMY2oBJJywYMOR5v9WiFlAT0k=
Message-ID: <47628EF3.8060009@keyaccess.nl>
Date: Fri, 14 Dec 2007 15:10:59 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <47628842.5060908@keyaccess.nl> <20071214140317.GA1007@elte.hu>
In-Reply-To: <20071214140317.GA1007@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-12-07 15:03, Ingo Molnar wrote:

> yep, i have updated the delay to 2 usecs. The latest patch is below, as 
> queued up in x86.git. (not yet queued up for .24 - it's pending testing 
> and more feedback, etc.)

Yes, I'd like feedback on the initial value thing:

http://lkml.org/lkml/2007/12/14/72

and Alan's comments here:

http://lkml.org/lkml/2007/12/12/221

And as to testing -- good luck finding a machine that cares at all ;-)

Rene.



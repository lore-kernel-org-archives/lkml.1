Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbXF2QCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbXF2QCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbXF2QCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:02:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:40813 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbXF2QCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eFAzFWJKL0UKzKliBELgrgrsWypWvGswOE2YTKQ/gH/h9azC2taDqnqjsHrM5YAkMi22L+VEAP98VY1fNXlPcd5v1SwYMVGMlkA5qRZzCWDWpbH06MI4KZVLhmn0LQXFbZN03iDYIK1SFR3RuyUFaACBwbrFUI6Jx5hK8zsSi5k=
Message-ID: <9a8748490706290902h7b2aba6ayfa4f01da89213bc7@mail.gmail.com>
Date: Fri, 29 Jun 2007 18:02:06 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Greg Huber" <ghuber@vanteon.com>
Subject: Re: Assistance debugging a Micrel network driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <468527A2.40909@vanteon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <468527A2.40909@vanteon.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/06/07, Greg Huber <ghuber@vanteon.com> wrote:
> Hello,
> I hope this is the right place to request some assistance, my apologizes
> if its not.
>
> I'm currently developing a network driver for a new controller chip. The
> driver is mostly complete and appears to be working,
> with the exception that messages received and sent up the stack appear
> to get dropped by a higher layer. Specifically we
> are seeing ARP "who is" requests go out, and the response come back
> (only 2 nodes on this network), the skb is configured
> and the frame is sent up with netif_rx (we haven't started supporting
> NAPI yet). The response seems to get dropped somewhere
> as another ARP "who is" request is sent. I am using the 2.6.21.5 kernel
> (compilied with network debugging turned on) and we
> have also tested with the 2.6.17 kernel, all acted the same.
>
> The upper layers obviously work so I'm sure it's something in my driver.
>
> I have turned on as much debugging in the kernel as I could find, but I
> get no messages. Could someone please let me know if
> there is additional debugging I should consider or if there is a dynamic
> way to turn on debugging in L2 and/or L3.
>
> Additionally, if anyone has any idea what might be happening, I would
> greatly appreciate any information.
>

You could start by publishing your complete source code. That would
make it a lot more likely that people can help you spot and fix
problems.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

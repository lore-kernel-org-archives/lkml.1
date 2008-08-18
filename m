Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYHRVho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYHRVho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYHRVhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:37:35 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:46110 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbYHRVhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vDond0rU0Dv4/EKaNI60zj/blQg2e1QCMhi8jA4COJCulLZxWURiUIoGSICZv6NvNq
         svdq+8yqHNqcQuEw9Joow9k09T46PIcLb1BZynES7YG6LkSF/iEAfzxg9d3CSjq9pidv
         aJObKFEdrwgQLWum4fNj5v/xP4xUNI0PLR0p4=
Message-ID: <84144f020808181437n34f3a339j3392ccccfdfd60f9@mail.gmail.com>
Date: Tue, 19 Aug 2008 00:37:33 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: BUG in free_block (tainted)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <48A9E97B.6060601@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A9E97B.6060601@simon.arlott.org.uk>
X-Google-Sender-Auth: f7b2f62fb83b1ec8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Tue, Aug 19, 2008 at 12:28 AM, Simon Arlott <simon@fire.lp0.eu> wrote:
> http://img169.imageshack.us/img169/1170/1005548cp9.jpg
>
> 2.6.27-rc3 09873-gb08c7f5
>
> (Tainted with fglrx, but X hadn't been run...)

Looks like SLAB corruption so fglrx could have caused this even if you
just loaded the module. Do you have CONFIG_DEBUG_SLAB enabled? If not,
you might want to try to reproduce this with it. Of course,
reproducing the oops without fglrx would be most helpful. :-)

                          Pekka

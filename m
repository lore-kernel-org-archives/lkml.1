Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbXJYPNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbXJYPNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbXJYPM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:12:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:60322 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759288AbXJYPMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:12:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jW0Y/Em7yMI/fJJ7WgJL7oCHquuwZHXDC54U62jyE/LV7m0E9oNIR6illLMblxAjzGCtjJZSl4aK8Y0eTtwBhaYaALwHG8H2oPn95GHAEchhKXMjYhczpQnzSXSYPYL13lDV6NXalg857DQV8yR7Ppcj1JNMctkmrhSOQ+qKCNo=
Message-ID: <84144f020710250812u1875e1d3g85d60862ac613ea7@mail.gmail.com>
Date: Thu, 25 Oct 2007 18:12:55 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Is gcc thread-unsafe?
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kleen, Andi" <ak@suse.de>
In-Reply-To: <alpine.LFD.0.999.0710250744420.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710251324.49888.nickpiggin@yahoo.com.au>
	 <alpine.LFD.0.999.0710250744420.30120@woody.linux-foundation.org>
X-Google-Sender-Auth: 869a1c3378e6dff8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/25/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> I think the OpenBSD people decided to actually do something about this,
> and I suspect it had *nothing* to do with license issues, and everything
> to do with these kinds of problems. I wish them all the luck, although
> personally I think LLVM is a much more interesting project.

The BSD people are adopting pcc [1] which is a rewritten version of
some C compiler originally developed in the late 70s. And yeah, it's
basically because they think gcc is becoming too painful to live with
[2].

                                  Pekka

  1. http://pcc.ludd.ltu.se/
  2. http://www.thejemreport.com/mambo/content/view/369/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbZBERby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbZBERby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759603AbZBERb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:31:26 -0500
Received: from gw.goop.org ([64.81.55.164]:38189 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759600AbZBERbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:31:25 -0500
Message-ID: <498B226A.2020900@goop.org>
Date: Thu, 05 Feb 2009 09:31:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Brian Gerst <brgerst@gmail.com>,
       Xen-devel <xen-devel@lists.xensource.com>, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: style fascism for xen assemblies
References: <4983AC87.5000304@goop.org> <498A87B5.3020808@gmail.com> <20090205150028.GD23903@elte.hu> <498B0E13.7060604@gmail.com>
In-Reply-To: <498B0E13.7060604@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Impact: style cleanup
>
> Make the following sytle cleanups.
>
> * drop unnecessary //#include from xen-asm_32.S
>   
Fine.
> * compulsive adding of space after comma
>   
Fine.
> * reformat multiline comments
>   

I don't really like what you've done here.  There are two problems:

    * If you're going to convert comments of the form

      /* This is a small comment which
         happens to be longer than a line. */
          

      then you should convert it to full winged-style, rather than just
      sticking '*' on the front of the second line.
    * All the big block comments look crowded and cramped now, which
      makes them harder to read and maintain.  All those '*'s are just
      visual noise. (They make a bit more sense in C code to distinguish
      comment from code, but asm code looks so different from comment
      that they're not necessary here.)

But Ingo's already pulled it, so I guess I'm stuck with it.

    J

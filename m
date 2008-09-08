Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYIHLNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYIHLNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 07:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYIHLNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 07:13:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:33953 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYIHLNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 07:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YaQ9VzwnK4Ml69JdxMMZXe6032rdDJ0/V88uMs+Pjo3iI8r7kVXHNdSx2mvJUjvkTf
         i32wPoBtJsfU1NuSkBjWZsGh68xxFfG4fGAjgOoRPMu46vqtV+g6KvUSP7HUD2UoaoxA
         LVt1alBJnTNtHyg3uLOtS1H0itMgVGRqfi6Ao=
Message-ID: <8ee0b8e80809080413r1eb75a2bu1b29ffdf06daa319@mail.gmail.com>
Date: Mon, 8 Sep 2008 13:13:39 +0200
From: "Jeroen van Rijn" <jvrnix@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Request for MCE decode (AMD Barcelona, fam 10h)
Cc: "Tony Vroon" <tony@vroon.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87abeivrdf.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220754742.8530.12.camel@localhost>
	 <87abeivrdf.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 12:55 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Tony Vroon <tony@vroon.org> writes:
>
>> HARDWARE ERROR. This is *NOT* a software problem!
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> Please contact your hardware vendor
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>> I realize that the linux kernel may be entirely blameless in this
>> situation,
>
> It is, like mcelog told you.
>
>> but I'd like to have some peer insight before I run after
>> vendors.
>
> It unfortunately turns out that mcelog logging is a tricky
> psychological problem. How should the warning above have
> looked like so that you would not have required "peer insight"
> and actually just contacted your hardware vendor?

I suppose mcelog might be extended to point at possible tools to get a
second opinion, in case the admin would like to to be entirely
certain. In their position I can understand them when their vendor
asks them if it's the hardware and what tests they've run to rule out
software.

Think for example a machine check that might point to faulty RAM, it
might direct the admin to run memcheck if mcelog alone isn't
compelling enough.

> Thank you.
>
> -Andi (who wonders if <blink> tags in syslog would be useful
> to solve this)

Yikes, ixnay to the <blinkay>. Next people will ask for flash support
to get all-singing and -dancing error messages.

-- Jeroen.

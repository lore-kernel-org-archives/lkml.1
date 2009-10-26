Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZJZR7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZJZR7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZJZR7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:59:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:10052 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZJZR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xRHOqvCbrU81/Re+lMaFXNF++S/J+P47V2JreEmcRj/OV28jaZIkF5PafHLFHSGT64
         BL2dojd697AhEFwZHJOwNg4213PpgNaehs4YSo9bofLc/HcYkRlmJt5IXO2NQDwRxgW5
         pjytap41Iz7ll/pPgWiEWHBh1hMWwBdgFLJVA=
MIME-Version: 1.0
In-Reply-To: <4AE5C7C0.3060305@mayc.ru>
References: <73a01bf20910260850v215385e6q2cbbf9133acd5e1e@mail.gmail.com>
	 <4AE5C7C0.3060305@mayc.ru>
Date: Mon, 26 Oct 2009 12:59:22 -0500
Message-ID: <73a01bf20910261059j74bb37a9td472efc21c5440ca@mail.gmail.com>
Subject: Re: FatELF & patents
From: Rayson Ho <raysonlogin@gmail.com>
To: "Anton D. Kachalov" <mouse@mayc.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 11:01 AM, Anton D. Kachalov <mouse@mayc.ru> wrote:
> Hmm... looks like patents talks about objects that stored in one file with
> arch-independent header.

Actually, the example in the PDF is an executable.


> My implementation (that is differ to Ryan's) do not use any headers except
> ELF header and just 3 bytes in it to store next location. So, it's patent
> clear.

However, there are 20 claims in the patent. Just using a different way
to store the architecture independent header might not be enough.


>  This is very common way to store different arch binaries...

The patent mentions only one prior art:

"One prior art attempt to provide a method for providing a single
application for a variety of architectures and formats is the ANDF
system, developed by OSF. This is an architecture neutral binary
format. A disadvantage of this scheme is that it requires conversion
to the native architecture at installation time."

I don't think there is anything similar to Apple's fat binary or
universal binary -- a single executable that can be executed on
different processor families.

The closest thing I can think of is the mixed of 32-bit / 64-bit
object files in a single archive on AIX.


> PS. Patents is evil.

Hence the heads up.

And yes, thanks but no thanks, I won't need an iPhone!!

Rayson



>
> Rgds,
> Anton
>

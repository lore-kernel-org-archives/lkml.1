Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554Ab0ANIpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0ANIpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 03:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534Ab0ANIpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 03:45:52 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:34256 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab0ANIpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:45:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ya193KsAPRappyLdvyVre1jZ25vFiQjYAW9YYRbaFyJwTZF3ErRcjGl2yBlcSi8ILw
         GqqsSSUs+pPNu/iuHEM6517hDOl/KsxxMxxkT1WbVnvcL4jkoetru1AXhcjmOiVdDbvi
         cbkVdpBDIjiA9fm8xDo22nTDZ4O0JYEgHoo3I=
MIME-Version: 1.0
In-Reply-To: <200912031822.44004.rusty@rustcorp.com.au>
References: <1259812252-22041-1-git-send-email-vapier@gentoo.org> 
	<200912031822.44004.rusty@rustcorp.com.au>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 14 Jan 2010 03:45:31 -0500
Message-ID: <8bd0f97a1001140045l3c75c49fk5894fcda78f0cf0b@mail.gmail.com>
Subject: Re: [PATCH] modpost: fix segfault in sym_is() with prefixed arches
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 3, 2009 at 02:52, Rusty Russell wrote:
> On Thu, 3 Dec 2009 02:20:52 pm Mike Frysinger wrote:
>> The sym_is() compares a symbol in an attempt to automatically skip symbol
>> prefixes.  It does this first by searching the real symbol with the normal
>> unprefixed symbol.  But then it uses the length of the original symbol to
>> check the end of the substring instead of the length of the symbol it is
>> looking for.
>
> Thanks, applied.

was this going to be pushed up for 2.6.33 then or wait for 2.6.34 ?
just curious so i can check it off from my local pile ...
-mike

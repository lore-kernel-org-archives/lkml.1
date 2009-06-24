Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZFXSl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZFXSl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZFXSlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:41:18 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:42990 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZFXSlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cijrjQAY/o/ucKDUXzAP/tUvQqbzeBFO7U2ELzIENB0ckV8eMaqxD8AAWCrDzOEihZ
         2DSJdQgzVFOAEJ8MUQ12NPjKCxDzKIY7eCuKzHQYmoaNJWHRJpcS7ZQrBirQypSRSIHn
         D+zg3P0WiZAzl0dtz83km95qW3uqtLNweWiT4=
MIME-Version: 1.0
In-Reply-To: <E1MJWrI-0002Bm-Bk@pomaz-ex.szeredi.hu>
References: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <a36005b50906241002g7a116d17n52e6af2ff9891f87@mail.gmail.com> 
	<E1MJWrI-0002Bm-Bk@pomaz-ex.szeredi.hu>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 24 Jun 2009 11:34:01 -0700
Message-ID: <a36005b50906241134x2f403213lb89e23d4c319a635@mail.gmail.com>
Subject: Re: [RFC] O_NOACC: open without any access
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 11:06, Miklos Szeredi<miklos@szeredi.hu> wrote:
> Is it available online somewhere?  If not, could you please post the
> relevant parts?

The OpenGroup publishes the man pages.  Here is what google finds:

http://www.opengroup.org/onlinepubs/9699919799/functions/open.html



> I suspect they are not quite what we want (both of them requring
> MAY_EXEC on file, no?)

No that's the differences between O_EXEC and O_SEARCH.  We
deliberately introduced two different names even though some OSes
might implement it using the same flag and even though in both cases
irritatingly the x permission bit is used.

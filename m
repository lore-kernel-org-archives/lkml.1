Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbZGENDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbZGENDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 09:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZGENDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 09:03:04 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34689 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZGENDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 09:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CJFNt0WLb+NGtvg1dR1MRycYSvPeXKjtvU7EjHLxoSXCBFM051uuaSFampHemjPYmJ
         xTcEthcbqiMfNymZJltgDrQEr/oxobMeLjiYrza1EShI6wNo0TNHWI4lbOopFeub6IpK
         /+d+ho6rU0UWCgfm2pLsaWHE22tdn5oy/1htk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] unifdef: teach it about defined(FOO) syntax
Date: Sun, 5 Jul 2009 15:07:08 +0200
User-Agent: KMail/1.8.2
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1158166a0906211121q51a8d320j1d9ab0e1570373da@mail.gmail.com> <20090626150453.77425669.akpm@linux-foundation.org> <20090626221219.GC26451@uranus.ravnborg.org>
In-Reply-To: <20090626221219.GC26451@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907051507.08384.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 June 2009 00:12, Sam Ravnborg wrote:
> > Unfortunately unifdef.c got changed after 2.6.30 and this patch throws
> > more rejects than I am comfortable about fixing.
> 
> Russell King actually implemented the same functionality (more or less).
> Denys - could you try if the one in the kernel is better/worse
> then the one you have here.
> 
> The implementation Russell did looks much simpler than this
> patch and so far it has only been a win.

I checked and linux-2.6.31-rc2 indeed has it fixed.
--
vda

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbZENQUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbZENQUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbZENQTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:19:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:45168 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760585AbZENQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:19:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XhZeidiDCSSXKUN5kUTQhKjMHryV92zWuv3Hhv0HmFj1uuF7mohjzmnobGzWFy5LyW
         774FBKpjQd3SLrkGniZLxqvO/7naYBqbk3J7Jsg3PEn8oui+ARzsKRf1IxaCWm4tOGru
         f7Vo3iwumTvprgBRUceT+cN9g3zmotHk5qF9w=
MIME-Version: 1.0
In-Reply-To: <20090514140138.GB10933@one.firstfloor.org>
References: <200904301408.09370.tobias.doerffel@gmail.com>
	 <877i0xib7d.fsf@basil.nowhere.org>
	 <a36005b50905120720p14e0ea0av79f99551262a920a@mail.gmail.com>
	 <20090512150408.GH19296@one.firstfloor.org>
	 <a36005b50905121045s62c16760p3aba003647a572c7@mail.gmail.com>
	 <1242277453.23058.35.camel@brick>
	 <a36005b50905140638r56f73095kfc669bae1333e2bd@mail.gmail.com>
	 <20090514140138.GB10933@one.firstfloor.org>
Date: Thu, 14 May 2009 09:19:38 -0700
Message-ID: <a36005b50905140919m3ab2356cqb3b8a32fd507e49e@mail.gmail.com>
Subject: Re: Specific support for Intel Atom architecture
From: Ulrich Drepper <drepper@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 7:01 AM, Andi Kleen <andi@firstfloor.org> wrote:
> How would you test that?

Compare runtimes with mov+bswap for some simple code which uses the
value after the conversion (e.g., just add to something).

Or in your case: get the Atom designers to comment.

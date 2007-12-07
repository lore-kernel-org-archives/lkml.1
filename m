Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXLGB2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXLGB2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 20:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXLGB1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 20:27:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:14328 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbXLGB1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 20:27:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sgea6X/2XEedeq0rVlSxHd1rSbETPBHMZq9lrIdQe1RNgCR0LCVSM/aFFofx7wXoirpoeiaCtzwRAlpjgWuVRqqMZcb1CFhvFZ6xd2BfIl7/c3mxC1WtrOHdJRgpr0S+BhdvYo92uzAMeYqh/MBrE/uTkvNRhnCjMEA4wEdzBrg=
Subject: Re: [PATCH x86/mm] x86 vDSO: canonicalize sysenter .eh_frame
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Miles Lane <miles.lane@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071207011429.EE2BC26F8D9@magilla.localdomain>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <47587796.8020705@free.fr>
	 <20071206143754.07a67819.akpm@linux-foundation.org>
	 <20071207011429.EE2BC26F8D9@magilla.localdomain>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 17:27:33 -0800
Message-Id: <1196990853.22471.15.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-06 at 17:14 -0800, Roland McGrath wrote:
> Some assembler versions automagically optimize .eh_frame contents,
> changing their size.  The CFI in sysenter.S was not using optimal
> formatting, so it would be changed by newer/smarter assemblers.
> This ran afoul of the wired constant for padding out the other vDSO
> images to match its size.  This changes the original hand-coded
> source to use the optimal format encoding for its operations.  That
> leaves nothing more for a fancy assembler to do, so the sizes will
> match the wired-in expected size regardless of the assembler version.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

Confirm this fixes the compile errors I was seeing with x86.git

Harvey


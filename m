Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYAPBxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYAPBxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYAPBwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:52:55 -0500
Received: from web36702.mail.mud.yahoo.com ([209.191.85.36]:49000 "HELO
	web36702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751076AbYAPBwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:52:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zMtWJgM5xL+Oe1LHvD5t9m+ro/a31xGIoBtR4BhYpjdcmy/JLC1q53U5IVTAlifo4s03fpu2lj3cGKBnh/+vZ8x4shY+rQD1JeCu3ws7RmX28feZUTDv6xbi5Q7h6xHbKsYTlxgphvQdvd1a2kN+gvP1LKeE1SkDkAFnQb51EoQ=;
X-YMail-OSG: 1yKa100VM1kPqAwNEXtE1A8AeFs.7MAYtZuKGEjZbiYE0lMdmQw58JCZ4xC17iH38fjEpBChHNQtqnJrrTr1vrmcQIqQDGOmZlw__vEwNWmJ.90-
Date: Tue, 15 Jan 2008 17:52:54 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200801151821.09413.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <582336.93194.qm@web36702.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> > Sony MemoryStick cards are used in many products manufactured by Sony. They
> > are available both as storage and as IO expansion cards. Currently, only
> > MemoryStick Pro storage cards are supported via TI FlashMedia MemoryStick
> > interface.
> 
> I tried it here and it doesn't work. My Vaio (PCG-FR285M) is from ~2003 (Is it too old
> for this?). I have some memory stick cards around so If you want a tester just drop me
> an email.
> 
> Regards,
> 
> 	Mariusz
> 

The build year is nowhere as helpful as 'lspci -vv' output. Then, given that your vaio is equipped
with tifm controller, you'll have to build the driver with debugging enabled and send me the
relevant excerpt of your system log.

You should have the following modules loaded, by the way:
memstick
mspro_block
tifm_core
tifm_7xx1
tifm_ms

The autoloading is handled via udev (so the relevant rules are not there yet).



      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYBXIfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYBXIfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 03:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYBXIfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 03:35:31 -0500
Received: from anyanka.rfc1149.net ([81.56.47.149]:38670 "EHLO
	mail2.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbYBXIfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 03:35:30 -0500
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2008 03:35:29 EST
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Reducing debuginfo size by removing unneeded includes
References: <20080207230304.GA4352@ghostprotocols.net>
	<p73ir0mxvby.fsf@bingen.suse.de>
	<20080224075821.GA7781@uranus.ravnborg.org>
Date: Sun, 24 Feb 2008 09:25:19 +0100
In-Reply-To: <20080224075821.GA7781@uranus.ravnborg.org> (Sam Ravnborg's message of "Sun\, 24 Feb 2008 08\:58\:21 +0100")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From: Samuel Tardieu <sam@rfc1149.net>
Organization: RFC 1149 (see http://www.rfc1149.net/)
X-WWW: http://www.rfc1149.net/sam
X-Jabber: <sam@rfc1149.net> (see http://www.jabber.org/)
X-OpenPGP-Fingerprint: 79C0 AE3C CEA8 F17B 0EF1  45A5 F133 2241 1B80 ADE6 (see http://www.gnupg.org/)
Message-Id: <2008-02-24-09-25-19+trackit+sam@rfc1149.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy> -feliminate-unused-debug-types -feliminate-unused-debug-symbols
Andy> -feliminate-dwarf2-dups

Sam> google did not turn up anything useful.  Do you have a poiter to
Sam> where these are described?

>From GCC (svn) man page:

   -feliminate-unused-debug-symbols
       Produce debugging information in stabs format (if that is sup‐
       ported), for only symbols that are actually used.

   -feliminate-unused-debug-types
       Normally, when producing DWARF2 output, GCC will emit debugging
       information for all types declared in a compilation unit, regard‐
       less of whether or not they are actually used in that compilation
       unit.  Sometimes this is useful, such as if, in the debugger, you
       want to cast a value to a type that is not actually used in your
       program (but is declared).  More often, however, this results in a
       significant amount of wasted space.  With this option, GCC will
       avoid producing debug symbol output for types that are nowhere used
       in the source file being compiled.

   -feliminate-dwarf2-dups
       Compress DWARF2 debugging information by eliminating duplicated
       information about each symbol.  This option only makes sense when
       generating DWARF2 debugging information with -gdwarf-2.

 Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/


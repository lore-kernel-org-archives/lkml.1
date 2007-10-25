Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbXJYJol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbXJYJol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbXJYJoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:44:32 -0400
Received: from anyanka.rfc1149.net ([81.56.47.149]:56580 "EHLO
	mail2.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbXJYJob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:44:31 -0400
Subject: Re: Is gcc thread-unsafe?
References: <MDEHLPKNGKAHNMBLJOLKAEOKHLAC.davids@webmaster.com> <200710251447.51370.nickpiggin@yahoo.com.au>
To: davids@webmaster.com, "Kleen\, Andi" <ak@suse.de>,
       "Torvalds\, Linus" <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200710251447.51370.nickpiggin@yahoo.com.au>
Date: Thu, 25 Oct 2007 11:44:28 +0200
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Samuel Tardieu <sam@rfc1149.net>
Organization: RFC 1149 (see http://www.rfc1149.net/)
Content-Transfer-Encoding: 8bit
X-WWW: http://www.rfc1149.net/sam
X-Jabber: <sam@rfc1149.net> (see http://www.jabber.org/)
X-OpenPGP-Fingerprint: 79C0 AE3C CEA8 F17B 0EF1  45A5 F133 2241 1B80 ADE6 (see http://www.gnupg.org/)
Message-Id: <2007-10-25-11-44-28+trackit+sam@rfc1149.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nick" == Nick Piggin <nickpiggin@yahoo.com.au> writes:

Nick> Either way, I think we really need a way to turn it off for
Nick> Linux.

Someone would need to add an option to disable the "cselim" pass in
GCC tree-ssa-phiopt.c as far as I can tell from reading GCC source.

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYKTItT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYKTItT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYKTItJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:49:09 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:46569 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbYKTItI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:49:08 -0500
From: Mikael Starvik <mikael.starvik@axis.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sam@ravnborg.org" <sam@ravnborg.org>
Date: Thu, 20 Nov 2008 09:48:45 +0100
Subject: headers-y for machines
Thread-Topic: headers-y for machines
Thread-Index: AclK7MxiaUtssM1BRaWckKI1QzC0IA==
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D053B05D40823@xmail3.se.axis.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {E1705BCF-C5D3-4505-96F0-AD48CE219902}
x-cr-hashedpuzzle: Cdha D25d Gwik Hgyx JM7v KkyN K5lI MEBM OT7a P/d/ SPxP
 TOwh UOZ8 WZsS Wbo0
 W6Yy;2;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHMAYQBtAEAAcgBhAHYAbgBiAG8AcgBnAC4AbwByAGcA;Sosha1_v1;7;{E1705BCF-C5D3-4505-96F0-AD48CE219902};bQBpAGsAYQBlAGwALgBzAHQAYQByAHYAaQBrAEAAYQB4AGkAcwAuAGMAbwBtAA==;Thu,
 20 Nov 2008 08:48:45
 GMT;aABlAGEAZABlAHIAcwAtAHkAIABmAG8AcgAgAG0AYQBjAGgAaQBuAGUAcwA=
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets say you have arch/arm/mach-xx/include/mach/myfile.h and want to add myfile.h to header-y. How do you do that?

I tried to add 

header-y += ../../maxh-xx/

in arch/arm/include/asm/Kbuild

and then
header-y += myfile.h in arch/arm/mach-xx/include/mach/Kbuild

but with that the file is installed is in /usr/mach-xx and not anywere under usr/include.

Thanks in advance
/Mikael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763918AbXEVMvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763918AbXEVMvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbXEVMvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:51:09 -0400
Received: from smtp2.wanadoo.co.uk ([193.252.22.157]:2594 "EHLO
	smtp2.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbXEVMvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:51:08 -0400
X-ME-UUID: 20070522125106563.0DBB12C00081@mwinf3101.me.freeserve.com
Message-ID: <4652E735.7000206@cjsoftuk.dyndns.org>
Date: Tue, 22 May 2007 13:51:01 +0100
From: Chris Malton <chrism@cjsoftuk.dyndns.org>
Organization: CJSoft UK
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NCPFS can't handle extended characters.
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms080906080306000407000203"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080906080306000407000203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I found a bug in NCPFS that I haven't the time to fix right now.

Here's the problem: if a file contains an extended (Charcodes 128-255) 
character, especially ` (or a even worse, an word converted ' (curled 
apostrophe) NCPFS goes butter side down on the directory listing.

It doesn't hand the machine, but it does cause some serious issues on 
our network, is there a way to make NCPFS understand extended characters 
in file names?

I would appreciate this being patched.

I'll get round to it post-exams if nobody else does.

Chris

--------------ms080906080306000407000203
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
--------------ms080906080306000407000203--


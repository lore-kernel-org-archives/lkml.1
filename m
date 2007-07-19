Return-Path: <linux-kernel-owner+w=401wt.eu-S937535AbXGSKaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937535AbXGSKaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763916AbXGSJ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:58:27 -0400
Received: from www.rsbac.org ([81.169.139.228]:32768 "EHLO www.rsbac.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764901AbXGSJ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:58:24 -0400
X-Greylist: delayed 1274 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 05:58:23 EDT
From: Amon Ott <ao@rsbac.org>
Organization: RSBAC
To: LKML <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] RSBAC 1.3.5 released
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 19 Jul 2007 11:37:01 +0200
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200707191137.02048.ao@rsbac.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone!

Rule Set Based Access Control (RSBAC) 1.3.5 has been released for both 
Linux kernels 2.4.34.5 and 2.6.22.1.
You can download the new version from http://www.rsbac.org

RSBAC is one of the leading access control systems for the Linux 
kernel with a good selection of access control models, see 
http://www.rsbac.org/why for more details.

Important changes since 1.3.4:
  * Fixes compilation errors with some configurations.
  * Some safety measures with null pointers.
  * Fixes an important bug with User Management password hashing,
introduced with newer 2.6 kernel crypto API.

Major improvements over the 1.2.x series:

Speed and scalability:
  - Cache for inherited filesystem attribute values
  - Automatically scaling hash tables for generic lists to minimize 
list lookups
  - Change network templates to handle up to 25 ip networks and up to 
10 port ranges per template
  - Various smaller optimizations

More control:
  - Fine grained setuid control also in RC (type of the target user) 
and ACL (acl at the target user) models
  - UNIX sockets as new filesystem target type, thus more fine grained 
control with RC types and ACLs
  - Further improved IPC communication control
  - RSBAC User Management password history with configurable length to 
avoid password reuse.
  - New request type AUTHENTICATE against USER targets. No 
authentication against RSBAC UM without this right in RC and ACL, so 
even harder to brute force attack

Amon.
-- 
http://www.rsbac.org - GnuPG: 2048g/5DEAAA30 2002-10-22


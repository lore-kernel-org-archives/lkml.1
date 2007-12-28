Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbXL1VLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbXL1VLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 16:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbXL1VL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 16:11:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:47343 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbXL1VL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 16:11:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=w0gRlPhyhAnBWTdFzur7zGlFpoPWInlj3tYmYjehq45Yfr6KvMngCPZH7x21RRSu+sTFUO+83noVwLXdC2Y6DFLpAOqN3w2gEfbPRbEB7xsMlFAEdTiUvBd10EqrjI6Ep9SR5f9WQqqy/t1tsrMrLkmmuqO4siezqrA/9o2Edqg=
Message-ID: <6101e8c40712281311p446f64e1xb28f8fc273545041@mail.gmail.com>
Date: Fri, 28 Dec 2007 22:11:25 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.23(?)=<] X used greatest stack depth: N bytes left
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in newer kernel I recently see this warnings:

X used greatest stack depth: N bytes left

X E { program name }
N E { x byte }

----------------8<--------------
...
khelper used greatest stack depth: 7496 bytes left
khelper used greatest stack depth: 7184 bytes left
...
khelper used greatest stack depth: 6328 bytes left
stty used greatest stack depth: 6180 bytes left
mount used greatest stack depth: 6156 bytes left
mknod used greatest stack depth: 5932 bytes left
...
wpa_supplicant used greatest stack depth: 5740 bytes left
...
dhclient3 used greatest stack depth: 5500 bytes left
----------------8<--------------

it is the "results" of the CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y options or it's other problem or feature?

-- 
Thanks,
Oliver

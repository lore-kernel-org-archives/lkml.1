Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbXEOAyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbXEOAyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbXEOAyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:54:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:35794 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXEOAyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:54:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eibyz82c63GBk5pb0SEytOgeuke2/D6eLOsVmC34PW/b2Wx3aUxSd0qbtMJJqazAn1PLuVxtFF94q4bArf2YRUvs4ThrIB/yf/MLLk1dkyJHDoHD/qieue98uIBDdxym4e3azX5OEWSpuUfMXXRzcdauykt6WJMJHeokM1/SN6A=
Message-ID: <3aa654a40705141754g21f5659bif25c0cbef8e8fcb0@mail.gmail.com>
Date: Tue, 15 May 2007 00:54:23 +0000
From: "Avuton Olrich" <avuton@gmail.com>
To: LMKL <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc1 creating an invalid randconfig
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I recently was using randconfig to fish for some broken configs, when
I came to a .config[1], The failure appeared to be related to
CONFIGFS, so I mailed the maintainer, and was told CONFIGFS is
selected but SYSFS is not, and it shouldn't be possible unless edited
by hand which I didn't. Next, I forwarded the conversation to the
Kconfig maintainer, to where I was told it's not directly a Kconfig
problem. Anyone know which maintainer takes responsibility in this
area?

[1] http://avuton.googlepages.com/config

Thanks
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.

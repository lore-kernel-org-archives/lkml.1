Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbZC3ToM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbZC3ToM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZC3Tn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:43:56 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:37407 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbZC3Tn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:43:56 -0400
X-Greylist: delayed 2578 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2009 15:43:55 EDT
From: Torsten Schmidt <torsten.schmidt@s2006.tu-chemnitz.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.29: Error during update of the kernel configuration.
Date: Mon, 30 Mar 2009 20:59:54 +0200
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903302059.54566.schmto@hrz.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: bf792412a9282b88258c217492ac655a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, 
I am not quit sure if this should be reported here: After loading the new 
kernel 2.6.29, the following error appears:

# make defconfig
*** Default configuration is based on 'i386_defconfig'
usr/Kconfig:145:warning: defaults for choice values not supported
#
# configuration written to .config
#

# make
scripts/kconfig/conf -s arch/x86/Kconfig
usr/Kconfig:145:warning: defaults for choice values not supported

*** Error during update of the kernel configuration.

make[2]: *** [silentoldconfig] Fehler 1
make[1]: *** [silentoldconfig] Fehler 2
make: *** [include/config/auto.conf] Fehler 2

Whats going wrong ?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYLCVlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYLCVlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYLCVkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:40:55 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:44669 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYLCVky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:40:54 -0500
Date: Wed, 03 Dec 2008 22:40:51 +0100
Message-Id: <529873894@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: odd habits with binary blobs.....
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19DYjY69D9KTDoyBpaTHg5jm5tdFWfmWDzHdTyNvsVYg8WVK
 2NgArZSwXq8xB/8OXcFnEXhI2LHVz0IKOdNQL+AK/s6W1kJI2s=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello, 

i gave r1soft`s new/free "hot copy" a try today and .... failed:

vserver2:/tmp/usr/sbin # ./hcp-setup
Gathering kernel information
Gathering kernel information complete.
Error: A network error occurred connecting to 'kmod32.r1soft.com'

what a pain....trying to setup a linux kernel module, the installer wants to phone home - and fails.

but it`s even worse - http://wiki.r1soft.com/display/LTR1D/hcp-setup tells:

BUILDING HOT COPY DRIVER FROM SOURCE

hcp-setup will tar up your kernel source tree or headers and upload them to an R1Soft build server over HTTPS using XML-RPC. Once your system's kernel headers or source have been uploaded the R1Soft build server will compile a Hot Copy device driver as a kernel module and hcp-setup will automatically download it to your system.

In order for hcp-setup to work your Linux server must have HTTPS Internet access to kmod32.r1soft.com (32-bit systems) and kmod64.r1soft.com (64-bit systems)


how weird is THAT?

did anybody ever come across such "build binary blobs remotely" system ?


ok, disqualified.  won`t touch it again, as i also don`t know what REALLY is transferred to the vendor - but i wonder what kernel devs think about such build system and what in-kernel alternative exists for this. (i think it doesn`t exist - but maybe somebody working on that ?)

if someone want`s to take a look or give a comment:

http://wiki.r1soft.com/display/LTR1D/hcp
http://www.r1soft.com/products/linux-hot-copy/

regards
roland

____________________________________________________________________
Psssst! Schon vom neuen WEB.DE MultiMessenger gehört? 
Der kann`s mit allen: http://www.produkte.web.de/messenger/?did=3123


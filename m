Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbZHCKxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbZHCKxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 06:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZHCKxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 06:53:52 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:37605 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZHCKxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Phmw8oyUKkzvGozB3kDnaFbaRgTMfnSkkf4WHHGwJzfoTzY2pN1M1/rYknkeU4dF7b
         O0M5lrXE9zksVcy9DQvsc29uMa9ucRCMLtAasY9hkr+ZVXsT5yk2TxNo0vMLRYu9DNxZ
         thBkfw2o7kdMgJoAY3SrtB2p9EBUR1vX6/I54=
Message-ID: <4A76C1B8.6080000@tuffmail.co.uk>
Date: Mon, 03 Aug 2009 11:53:44 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: linux acpi <linux-acpi@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: WMI module autoloading (for hp-wmi, dell-wmi, tc1100-wmi)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I believe you had a patch to add support for auto-loading of wmi
modules.  But it stalled because it also added a userspace interface to
WMI in sysfs, which didn't fit very well.

So at the moment, only acer-wmi is autoloaded, because it has a DMI
autoload hack.  hp-wmi, dell-wmi, and tc1100-wmi are out of luck, even
though a second DMI hack was proposed for dell-wmi.

Would it be possible to add the auto-load support on it's own?  Is it
just a matter of someone taking the time to cherry-pick the auto-loading
bits from the original patch, and test the result?

Thanks
Alan

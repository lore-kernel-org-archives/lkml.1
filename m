Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYAWGmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYAWGmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 01:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYAWGm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 01:42:26 -0500
Received: from nn7.de ([85.214.94.156]:59746 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbYAWGm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 01:42:26 -0500
Subject: 24rc8: unregister_netdevice: waiting for ... to become free. Usage
	count = 1?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Jan 2008 07:42:21 +0100
Message-Id: <1201070541.22958.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

since some 2.6.24rc version I suddenly experience such messages on
console when trying to shutdown a vpn connection:

unregister_netdevice: waiting for tun0 to become free. Usage count = 1

or when removing an usb wlan dongle (although it was ifconfig wlan0
down'd before)

unregister_netdevice: waiting for wlan0 to become free. Usage count = 1

Then only when all potential connections going over that iface are gone
these messages disappear (sometimes this does not happen and the kernel
then hangs on reboot...)

Is this intended?

Soeren

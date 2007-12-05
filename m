Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbXLELv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbXLELv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 06:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXLELui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 06:50:38 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:4255 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbXLELug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 06:50:36 -0500
Date: Wed, 5 Dec 2007 12:50:01 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/3] driver core: Fix s390, get default driver attributes
 for free.
Message-ID: <20071205125001.5b64442d@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I spent some time fixing up the driver tree on s390 and found that the
easiest way to do so is to introduce default attribute groups for
device drivers (like for devices).

Since I'm lazy, I didn't take care to delay the uevent for device
drivers to after adding the attribute groups, but this should be done
when struct device_driver is converted to the new kobject interface.

Cornelia

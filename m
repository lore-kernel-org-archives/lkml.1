Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZBVGO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZBVGO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 01:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZBVGOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 01:14:20 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:52514 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbZBVGOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 01:14:20 -0500
MIME-Version: 1.0
Date: Sun, 22 Feb 2009 01:14:18 -0500
X-Google-Sender-Auth: 1693987750b71239
Message-ID: <5aa163d00902212214w71923b5cq79d534bf39f68e88@mail.gmail.com>
Subject: PATCH [0/2] Documentation: fix docs related to struct 
	device_attribute and sysfs
From: Mike Murphy <mamurph@cs.clemson.edu>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

The following patch set fixes the presentation of struct
device_attribute in two documentation files:
Documentation/driver-model/device.txt and
Documentation/filesystems/sysfs.txt. Both files give conflicting
definitions of struct device_attribute and supporting functions,
neither of which corresponds to the actual structure definition in
include/linux/device.h. I was initially led astray when trying to add
a sysfs interface to a driver, following these documents. This patch
set fixes the documents to make the structure definitions consistent
with the actual device_attribute structure.

Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0BDGZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 01:25:11 -0500
Received: from mout.perfora.net ([74.208.4.195]:52951 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab0BDGZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 01:25:10 -0500
MIME-Version: 1.0
From: vb@vsbe.com
Date: Wed, 3 Feb 2010 22:24:46 -0800
Message-ID: <f608b67d1002032224r74450689ge416382a1db8e4cf@mail.gmail.com>
Subject: associating miscdevice with inode
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-Provags-ID: V01U2FsdGVkX1+lO8kG2XeAet22/OFyQ76Ybhv5gB5WwbPlP6X
 TF761T7D/H+oZKbnhBhJhapdVz4uHFmLYlovl+6U33XIlCKHbM
 hNs6P/IiAWrBQ6EnQDQdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

guys,

say I have a misc device driver which instantiates several devices.
When a file operation on this device is invoked, I need to be able to
figure out which device is being accessed. All available information
are

struct inode and struct file. Is there a way to find the address of
the miscdevice structure passed to misc_register() when this device
was created?

TIA,
/vadim

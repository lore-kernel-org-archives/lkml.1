Return-Path: <linux-kernel-owner+w=401wt.eu-S964838AbXBLKFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbXBLKFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 05:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964828AbXBLKFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 05:05:09 -0500
Received: from dsl.static81213182239.ttnet.net.tr ([81.213.182.239]:15192 "EHLO
	bonsai.taydin.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964838AbXBLKFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 05:05:08 -0500
X-Greylist: delayed 1523 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 05:05:08 EST
From: Timur Aydin <ta@taydin.org>
To: linux-kernel@vger.kernel.org
Subject: Adjusting destination pointer with copy_to_user
Date: Mon, 12 Feb 2007 11:39:44 +0200
Message-ID: <87ire7af4v.fsf@bonsai.taydin.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am passing a packet consisting of a fixed length header and a
variable length data block to a user mode application. The user mode
application passes the pointer of its buffer with an ioctl call
(buff_ptr). When the driver receives buff_ptr, it makes two calls to
pass the packet to user mode:

copy_to_user(buff_ptr, header, header_size);
copy_to_user(buff_ptr + header_size, data, data_size);

Is this a valid usage? Or can I only use buff_ptr here?

Timur

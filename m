Return-Path: <linux-kernel-owner+w=401wt.eu-S965662AbXDBS17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965662AbXDBS17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 14:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965661AbXDBS17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 14:27:59 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:60727 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965522AbXDBS16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 14:27:58 -0400
Subject: RE: [PATCH 3/4] [SCSI]stex: fix reset recovery for console device
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>,
       Promise_Linux <Promise_Linux@promise.com>
In-Reply-To: <B70A50D07063384EB9BCE3330D18414F0327EBC5@nonameb.ptu.promise.com>
References: <B70A50D07063384EB9BCE3330D18414F0327EBC5@nonameb.ptu.promise.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 13:27:55 -0500
Message-Id: <1175538475.3680.69.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 11:14 -0700, Ed Lin wrote:
> I just saw the routine name scsi_eh_try_stu, and didn't notice the
> allow_restart (partly because I thought it was not harmful...).
> But the TEST_UNIT_READY must stay.

Sure ... I was just checking since your change log implied you'd seen
the problem from the error handler ... however, we can add it ...
there's a possibility of getting spin up on init from sd anyway.

James



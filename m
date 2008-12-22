Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbYLVRWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbYLVRWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 12:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYLVRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 12:22:11 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:51490 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYLVRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 12:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Lfbb4jh0XP9yO4kiHioiIqvkV0k1VvSfTBHPk7o5eaC/5+f8+aXibDnD0QhdSftj69
         1YCIpxxJySoOHvnA7PBJXffPhS9/zXKTNz7dSObT7R3kypmIFO5SEu1NDR4OWgFpb5dM
         lMWSx7G/YR43pp89941Am/Ds+JUIuE8h4Fv+E=
Message-ID: <37d33d830812220922l5a0bc36et5dd1f9853f9cd33@mail.gmail.com>
Date: Mon, 22 Dec 2008 22:52:08 +0530
From: "Sandeep K Sinha" <sandeepksinha@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Device mapper support for more than one target ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After looking at the complete implementation of device mappers, I
figured out that we can have more than one target for a mapped device
then why do we have a check for the number of target to be equal to
one , in dm_blk_ioctl ( ) in drivers/md/dm.c

http://lxr.linux.no/#linux+v2.6.27.10/drivers/md/dm.c#L337

I think this is a old piece of code and we need to modify it.

Kindly suggest !


-- 
Regards,
Sandeep.





 	
"To learn is to change. Education is a process that changes the learner."

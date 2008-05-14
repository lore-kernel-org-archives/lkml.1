Return-Path: <linux-kernel-owner+w=401wt.eu-S1763950AbYENTyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763950AbYENTyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763767AbYENTyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:54:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:38379 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763143AbYENTyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HDziHv7a6ccPIA1dTvjekMuqX6FzPmNqj8X80tXoUH/N9exWiIWukEOwM5AfCQFzx0b/Z1/ELJ13QmK8lHEaxe8+c2065hK9zg7GaPlJLhebeZWr5tp5Vg7wdP4TBTsz62hib1kTHXewuujbjqZUqfKv7o4iiti3Hk1wyt2kxWw=
Message-ID: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
Date: Wed, 14 May 2008 21:54:03 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: How to avoid data copies in a driver ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to optimize my driver, which receives data through a fifo and gives
them to a user space application. In turns this application moves this data
into a file.

To avoid several useless copies, I'd like the application to pass to the driver
a  file descriptor (?) to  the driver and then the driver can directly move the
received data to that file.

Could anybody give me some example of such scheme ?

Thanks,
-- 
Francis

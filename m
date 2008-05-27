Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYE0GuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYE0GuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbYE0GuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:50:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:39999 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYE0GuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=O83QBJ+1AeUmpWVgIs5Z8xHkUWAi4wzNNy0bE+GAabsDc/Uo9KwUXKcczDUMODKHrQddcpi9ChpMHRcUWPQ0GoGBaj01zMwXmrUoPGPFZqmB3luYZcU8rQpVRkfF6Wdm5v3nxyvy3fHPkcCRnTWmwVa9CDOFPXgNvxOoTM1WEcM=
Message-ID: <a5eaedfa0805262350w75f5eaa0s9d4ae29a2b7b15d8@mail.gmail.com>
Date: Tue, 27 May 2008 12:20:09 +0530
From: "Veda N" <veda74@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: i2c writes different sizes
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I am writing a kernel module that makes lots of i2c writes.

   Each write is different. Some writes need only device command and data.
   Some need device command, <some more paramters> <data>

   there are different ways of doing this. but i want to know how it is done
   in standard way. if it is simple read/write of 8 or 16 bit register write.
   it is easy. but in my case instead of register address it is command
   and command takes lots of parameters. which is different for different
   commands. i am a newbie and i dont know how to do it.

  Are there any drivers that implement such a mechanism.

  I want help so that i can see how it is done in standard way
  and implement it in my own module.


Thanks you.

Regards,
vedan

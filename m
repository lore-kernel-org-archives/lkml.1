Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbYFCA1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbYFCA1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 20:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYFCA1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 20:27:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:40161 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbYFCA1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 20:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=OekY03wqpGeGz17bwgGEAfddDYgEgUyN/ECmo+Bl3ZJK9A1tw/woi3RNW1LOFBSDeIz385BAu7eqGldZgPxQlqIsk9srp1nUELmQ/it2vIc/v1vnoy7oFQcDoGfPi43Dl45WndQTT+dJqaRDt4wXhw5ctXxg4vGXN2ObokZj3Ys=
Message-ID: <e9e943910806021727h111b0e57qeea0032d164e0ffb@mail.gmail.com>
Date: Tue, 3 Jun 2008 01:27:10 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Subject: Correct EXT3_TOPDIR_FL behaviour
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 43aa9dfdc5ee649e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I'm looking at http://bugzilla.kernel.org/show_bug.cgi?id=9866, where
the reporter is claiming that EXT3_TOPDIR_FL (chattr +T) is behaving
incorrectly by being inherited from the parent. As mentioned in the
bug, it also only seems to only make sense for directories but
ext{2,3,4} is happy to set it on anything. It seems to me that the
reporter is correct and the behaviour should be changed to prevent the
flag being inherited and to limit it to directories only. If there is
no disagreement I'll follow-up with patches accordingly.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan

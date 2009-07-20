Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbZGTMrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbZGTMrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZGTMrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:47:31 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:58318 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZGTMra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LmzSkQSJ0S8XNUDadTt5FxoVOKHADqtio0KWIfA9p7afsSsJMuNXEyUVrLK3X4M6bX
         rCrdWOYJRf0wEVk7SKuCzfK8YbNmCPwQTGO5+Xpe9aQFJ5T1hZgnWEoIucbUErnPpehN
         rWr+zzrQvdi083mWav0sh5QQOBYCjJ2Q8yVdU=
MIME-Version: 1.0
Date: Mon, 20 Jul 2009 17:47:30 +0500
Message-ID: <d6bd61d30907200547o29ab90c1p36d95a701e579bd9@mail.gmail.com>
Subject: [Newbie] Getting pages of files accessed by a process from a RAM 
	image
From: "M. Shuaib Khan" <aries.shuaib@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a newbie question, and I asked and searched elsewhere but
couldn't get a satisfactory answer, so bothering you guys. Please bear
with me.

I am trying to get all the pages of files opened by a process, by
manually traversing the structures in a RAM image taken using dd. So
far what I know is that I can do it using the radix_tree_node, which
has data members height, count, and slots, and which I think refer to
the level of indirection in slots, the page count, and the addresses
of the page frames respectively. Correct? What does the addresses in
the slots point to? Page descriptors?

Also, when the nrpages of a file is 1, the height in radix_tree_root
is reported as 0, in that case how can we access that single page
because  we can't get the count and slots addresses in
radix_tree_node.

Any input, web pointers welcomed.

Thanks

--
M. Shuaib Khan

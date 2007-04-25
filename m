Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbXDYF1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbXDYF1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 01:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbXDYF1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 01:27:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:10204 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbXDYF1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 01:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ihBYc9Kh4v9mEq9Rc2fkt+9WD3QnyRMnCaUxXRWF89nzQuPSyRdSGzMKsS5EqVrf72m7yM4qNweskQw73ZrCqUn8w8rT5UCbm2ewusbef1ahFDzKYes7P9fxFZhwismpGLnbUCTdsIxQNfiXap/eNJY6dvcX61SlDYj5u7ZCQX0=
Message-ID: <a44ae5cd0704242227x14986fe3v5c2fc3a5bceedc89@mail.gmail.com>
Date: Tue, 24 Apr 2007 22:27:44 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- software suspend failed (1 tasks refusing to freeze)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ 1251.506964] PM: Preparing system for mem sleep
[ 1251.514790] Stopping tasks ...
[ 1271.456065] Stopping user space processes timed out after 20
seconds (1 tasks refusing to freeze):
[ 1271.456243]  multiload-apple
[ 1271.456291] Restarting tasks ... done.

This isn't happening under earlier builds I've tested.  How can I debug this?

Thanks,
          Miles

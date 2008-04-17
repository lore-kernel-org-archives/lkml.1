Return-Path: <linux-kernel-owner+w=401wt.eu-S935953AbYDQKFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935953AbYDQKFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935039AbYDQJqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:46:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:25735 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934919AbYDQJqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZxFRx8z+nX6K0UIxkrFAplVDX1IJW4Myc7qmHgUEYkTlmwX+mA9pepm+sPqPVLpZKnuYo0tUNDCJCnqiOcZmm/s8IVT1NV0gE1GWyfkHxviOJGNCoGoE41o385GwWefwBSaLG5x0cAu8lW6K4yjbfrX7eGY1YDoh5Q0d7FkFXsY=
Message-ID: <e2e108260804170246i673a2e08q333eeae48467ed4@mail.gmail.com>
Date: Thu, 17 Apr 2008 11:46:14 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.25 section mismatches
Cc: rufus-azrael@numericable.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently there is a significant number of section mismatches in the
2.6.25 kernel. These were already reported against 2.6.25-rc1 and are
still present in the final 2.6.25 release. These section mismatches
show up at least on the i386 and x86_64 architectures. Maybe it's a
good idea before a patch is merged not only to check whether the patch
applies cleanly but also to check whether it doesn't create any new
section mismatches ?

See also http://bugzilla.kernel.org/show_bug.cgi?id=9974.

Bart.

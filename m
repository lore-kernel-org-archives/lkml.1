Return-Path: <linux-kernel-owner+w=401wt.eu-S1765616AbXLNBqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765616AbXLNBqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 20:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761539AbXLNBq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 20:46:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:44845 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbXLNBq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 20:46:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=wfQRrp3o+0779ysXrg269C/jBmueczb6XQCchAgWeW1jlZtVF/u/ZnUnyMILZ3qGsxLlvX7LIViKJxYW78gNoqUD3np+nQBdVKjm6FYTxw953Sa0nzpj/TwtX/ltVOReUm/sG3R70Ye5GZ7PLlU5Ol/9PltdANVwDZIXA9y5ulk=
Message-ID: <2c0942db0712131746s7da91f2bkf45b3e1ddf16d1f3@mail.gmail.com>
Date: Thu, 13 Dec 2007 17:46:24 -0800
From: "Ray Lee" <ray@madrabbit.org>
To: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Regression: Wireshark sees no packets in 2.6.24-rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 00980a01c946ea24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tshark -i eth0, eth1, lo are all empty. Works under 2.6.23.0 just
fine. A quick scan of the log between 2.6.24-rc3 and current tip
(-rc5) doesn't show any obvious fixes, but then again, what do I know.
I'll check current tip on the weekend when I'll have the luxury to
have my main system down long enough for a test. Right now I'm kinda
up against a deadline, but didn't want to leave it unreported. Should
be easy for someone else to confirm or deny whether current tip has
the problem.

Ray

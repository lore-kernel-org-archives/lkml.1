Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYJKQ6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYJKQ6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 12:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYJKQ5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 12:57:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:23119 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYJKQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 12:57:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=EKgeZ9dVXam3LA4d247IUesi3dWUKCmLHe7SaWz44512mdNtNu/Jd8EDJcSp8QRIUo
         ETCm8gMl5Ywgc3ksXReSPmyizCSrsOJiEPCV57+OjX7QMhsrYBTTuVWTUEBAShGEEolB
         T9xLE08Q+A1sUDrWxctlv4Z60TYOqlkO20xZo=
Message-ID: <48F0DB0C.7060201@tuffmail.co.uk>
Date: Sat, 11 Oct 2008 17:57:48 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: acpi-test tree on eeepc: EC error message on second resume
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just run an acpi-test kernel on my EeePC and noticed a new issue. 
It seems to be caused (or revealed) by the EC interrupt transaction patch.

On the second suspend/resume cycle, I see a kernel error message.

[   78.747707] ACPI: Waking up from system sleep state S3
[   79.330001] ACPI: EC: input buffer not empty, aborting transaction
[   79.423327] ACPI: EC: non-query interrupt received, switching to
interrupt mode

I still don't see any issues in the code.  I'll try getting a DEBUG
trace to see the EC interrupts.  Any other suggestions?

Thanks
Alan
